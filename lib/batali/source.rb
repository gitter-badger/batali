require 'batali'

module Batali
  # Source of asset
  class Source < Utility

    autoload :Path, 'batali/source/path'
    autoload :Site, 'batali/source/site'
    autoload :Git, 'batali/source/git'
    autoload :ChefServer, 'batali/source/chef_server'

    attribute :type, String, :required => true, :default => lambda{ self.name }

    # @return [String]
    def unit_version
      raise NotImplementedError.new 'Abstract class'
    end

    # @return [Array<Array<name, constraints>>]
    def unit_dependencies
      raise NotImplementedError.new 'Abstract class'
    end

    # @return [String] directory containing contents
    def asset
      raise NotImplementedError.new 'Abstract class'
    end

    # @return [TrueClass, FalseClass]
    def clean_asset(asset_path)
      if(self.respond_to?(:cache))
        false
      else
        if(File.exists?(asset_path))
          FileUtils.rm_rf(asset_path)
          true
        else
          false
        end
      end
    end

    # @return [TrueClass, FalseClass]
    def ==(s)
      s.is_a?(Source) && attributes.map do |key, attr|
        key if attr[:equivalent]
      end.compact.all? do |key|
        attributes[key] == s.attributes[key]
      end
    end

    # Detect differences in equivalency
    #
    # @param s [Source]
    # @return [Smash]
    def diff(s)
      Smash.new.tap do |_diff|
        self.class.attributes.each do |k,v|
          if(v[:equivalent])
            s_attrs = s.respond_to?(:attributes) ? s.attributes : {}
            unless(attributes[k] == s_attrs[k])
              _diff[k] = [attributes[k], s_attrs[k]]
            end
          end
        end
      end
    end

    # Build a source
    #
    # @param args [Hash]
    # @return [Source]
    # @note uses `:type` to build concrete source
    def self.build(args)
      type = args.delete(:type)
      unless(type)
        raise ArgumentError.new 'Missing required option `:type`!'
      end
      unless(type.to_s.include?('::'))
        type = [self.name, Bogo::Utility.camel(type)].join('::')
      end
      klass = Bogo::Utility.constantize(type)
      unless(klass)
        raise TypeError.new "Unknown source type provided `#{type}`!"
      else
        klass.new(args.merge(:type => type))
      end
    end

  end
end
