require 'rubygems/tasks/task'

require 'rubygems/builder'

module Gem
  class Tasks < Rake::TaskLib
    module Build
      class Task < Tasks::Task

        protected

        def build_task(name,extname=name)
          directory Project::PKG_DIR

          namespace :build do
            namespace name do
              @project.builds.each do |build,packages|
                gemspec = @project.gemspecs[build]
                path    = packages[extname]

                # define file tasks, so the packages are not needless re-built
                file(path => [Project::PKG_DIR, *gemspec.files]) do
                  build(path,gemspec)
                end

                task build => path
              end
            end
          end

          desc "Builds all #{extname} packages"
          multi_task "build:#{name}", @project.builds.keys

          task :build => "build:#{name}"
        end

        #
        # @param [String] path
        #
        # @param [Gem::Specification] gemspec
        #
        # @abstract
        #
        def build(path,gemspec)
        end

      end
    end
  end
end
