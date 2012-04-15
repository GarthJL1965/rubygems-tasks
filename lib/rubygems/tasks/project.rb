require 'rake/tasklib'

require 'set'

module Gem
  class Tasks < Rake::TaskLib
    class Project

      SCM_DIRS = {
        :git => '.git',
        :hg  => '.hg',
        :svn => '.svn'
      }

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
      # @return [Symbol, nil]
      #   The SCM the project is using.
      #
      attr_reader :scm

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
      # Initializes the project.
      #
      # @param [String] root
      #   The root directory of the project.
      #
      def initialize(root=Dir.pwd)
        @root = root
        @name = File.basename(@root)

        @scm, _ = SCM_DIRS.find do |scm,dir|
                    File.directory?(File.join(@root,dir))
                  end

        Dir.chdir(@root) do
          @gemspecs = Hash[glob('*.gemspec').map { |path|
            [File.basename(path).chomp('.gemspec'), Specification.load(path)]
          }]
        end

        @builds = {}

        @gemspecs.each do |build,gemspec|
          @builds[build] = Hash.new do |packages,format|
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
      # @api semipublic
      #
      def self.directories
        @@directories ||= Hash.new do |hash,key|
          hash[key] = new(key)
        end
      end

      #
      # Searches for paths within the project.
      #
      # @param [String] pattern
      # 
      # @yield [path]
      #
      # @yieldparam [String] path
      #
      # @return [Array<String>]
      #
      def glob(pattern,&block)
        Dir.glob(File.join(@root,pattern),&block)
      end

      #
      # @return [Boolean]
      #
      def bundler?
        @bundler
      end

    end
  end
end
