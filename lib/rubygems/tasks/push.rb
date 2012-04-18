require 'rubygems/tasks/task'

module Gem
  class Tasks < Rake::TaskLib
    class Push < Task

      PKG_DIR = 'pkg'

      attr_accessor :host

      def initialize(options={})
        super()

        @host = options[:host]

        yield self if block_given?
        define
      end

      def define
        namespace :push do
          @project.builds.each do |build,packages|
            path = packages[:gem]

            task build => path do
              arguments = []
              arguments << '--host' << @host if @host

              sh 'gem', 'push', path, *arguments
            end
          end
        end

        multi_task 'push', @project.builds.keys

        # backwards compatibility for Hoe
        task :publish => :push
      end

    end
  end
end