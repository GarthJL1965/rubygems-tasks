require 'rubygems/tasks/task'

module Gem
  class Tasks
    module Setup
      module Git
        #
        # The `setup:git:submodules` task.
        #
        class Submodules < Task

          #
          # Initializes the `setup:git:submodules` task.
          #
          # @param [Hash] options
          #   Additional options.
          #
          def initialize(options={})
            super()

            yield self if block_given?
            define
          end

          #
          # Defines the `setup:git:submodules` task.
          #
          def define
            namespace :setup do
              namespace :git do
                task :submodules do
                  run 'git', 'submodule', 'init'
                  run 'git', 'submodule', 'update'
                end
              end
            end

            desc "Initializes git submodules"
            task :setup => 'setup:git:submodules'
          end

        end
      end
    end
  end
end
