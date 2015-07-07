require 'rubygems/tasks/repository'

require 'set'

module Gem
  class Tasks
    #
    # @api semipublic
    #
    class Project

      # The `pkg/` directory.
      PKG_DIR = 'pkg'

      #
      # The project directory.
      #
      # @return [String]
      #   The path to the project.
      #
      attr_reader :root

      #
      # The name of the project.
      #
      # @return [String]
      #   The project name.
      #
      attr_reader :name

      #
      # The repository of the project.
      #
      # @return [Repository]
      #
      # @since 0.3.0
      #
      attr_reader :repository

      #
      # The builds and gemspecs of the project.
      #
      # @return [Hash{String => Gem::Specification}]
      #   The hash of builds and their gemspecs.
      #
      attr_reader :gemspecs

      #
      # The builds and their packages.
      #
      # @return [Hash{String => Hash{String => String}}]
      #   The hash of builds and their respective packages.
      #
      attr_reader :builds

      #
      # The name of the primary gemspec.
      #
      # @return [String]
      #   The gemspec name.
      #
      attr_reader :primary_gemspec

      #
      # Initializes the project.
      #
      # @param [String] root
      #   The root directory of the project.
      #
      def initialize(root=Dir.pwd)
        @root = root
        @name = File.basename(@root)

        @repository = Repository.new(@root)

        Dir.chdir(@root) do
          @gemspecs = Hash[Dir['*.gemspec'].map { |path|
            [File.basename(path,'.gemspec'), Specification.load(path)]
          }]
        end

        @primary_gemspec = if @gemspecs.has_key?(@name)
                             @name
                           else
                             @gemspecs.keys.sort.first
                           end

        @builds = {}

        @gemspecs.each do |name,gemspec|
          @builds[name] = Hash.new do |packages,format|
            packages[format] = File.join(PKG_DIR,"#{gemspec.full_name}.#{format}")
          end
        end

        @bundler = File.file?(File.join(@root,'Gemfile'))
      end

      #
      # Maps project directories to projects.
      #
      # @return [Hash{String => Project}]
      #   Project directories and project objects.
      #
      def self.directories
        @@directories ||= Hash.new do |hash,key|
          hash[key] = new(key)
        end
      end

      #
      # The current project.
      #
      # @return [Project]
      #
      # @since 0.3.0
      #
      def self.current
        directories[Dir.pwd]
      end

      #
      # @see {Repository#scm}
      #
      def scm
        @repository.scm
      end

      #
      # Retrieves a gemspec for the project.
      #
      # @param [String] name (@primary_gemspec)
      #   The gemspec name to retrieve.
      #
      # @return [Gem::Specification]
      #   The requested gemspec.
      #
      def gemspec(name=nil)
        name ||= @primary_gemspec

        unless @gemspecs.has_key?(name)
          raise(ArgumentError,"unknown gemspec: #{name}")
        end

        return @gemspecs[name]
      end

      #
      # Specifies whether the project uses Bundler.
      #
      # @return [Boolean]
      #
      def bundler?
        @bundler
      end

    end
  end
end
