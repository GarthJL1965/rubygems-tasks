require 'rubygems/tasks/task'

module Gem
  class Tasks
    module Setup
      #
      # The `setup:submodules` task.
      #
      class Submodules < Task

        #
        # Initializes the `setup:submodules` task.
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
        # Defines the `setup:submodules` task.
        #
        def define
          namespace :setup do
            task :submodules do
              run 'git', 'submodule', 'init'
              run 'git', 'submodule', 'update'
            end
          end

          desc "Initializes git submodules"
          task :setup => 'setup:submodules'
        end

      end
    end
  end
end
