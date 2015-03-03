require 'batali'

module Batali
  class Command

    # Resolve cookbooks
    class Resolve < Command

      # Resolve dependencies and constraints. Output results to stdout
      # and dump serialized manifest
      def execute!
        file = BFile.new(opts.fetch(:file, File.join(Dir.pwd, 'Batali')))
        manifest = Manifest.build(File.join(File.dirname(file.path), 'batali.manifest'))
        score_keeper = ScoreKeeper.new(:manifest => manifest)
        system = Grimoire::System.new
        run_action 'Loading sources' do
          file.source.map(&:units).flatten.map do |unit|
            system.add_unit(unit)
          end
          nil
        end
        requirements = Grimoire::RequirementList.new(
          :name => :batali_resolv,
          :requirements => file.cookbook.map{ |ckbk|
            [ckbk.name, *(ckbk.constraint ? ckbk.constraint : '> 0')]
          }
        )
        solv = Grimoire::Solver.new(
          :requirements => requirements,
          :system => system,
          :score_keeper => score_keeper
        )
        results = []
        run_action 'Resolving dependency constraints' do
          results = solv.generate!
          nil
        end
        if(results.empty?)
          ui.error 'No solutions found defined requirements!'
        else
          ideal_solution = results.pop
          ui.info "Found #{results.size} solutions for defined requirements."
          ui.info 'Ideal solution:'
          ui.puts ideal_solution.units.sort_by(&:name).map{|u| "#{u.name}<#{u.version}>"}
          manifest = Manifest.new(:cookbook => ideal_solution.units)
          File.open('batali.manifest', 'w') do |file|
            file.write MultiJson.dump(manifest, :pretty => true)
          end
        end
      end

    end

  end
end
