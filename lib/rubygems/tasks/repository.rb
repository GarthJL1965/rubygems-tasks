module Gem
  class Tasks
    #
    # @since 0.3.0
    #
    class Repository

      # Supported SCMs and their control directories.
      SCM_DIRS = {
        git: '.git',
        hg:  '.hg',
        svn: '.svn'
      }

      #
      # Path to the repository.
      #
      # @return [String]
      #
      attr_reader :root

      #
      # The type of repository.
      #
      # @return [:git, :hg, :svn, nil]
      #
      attr_reader :scm

      #
      # Initializes the repository.
      #
      # @param [String] path
      #   Path to the repository directory.
      #
      def initialize(root)
        @root = root

        @scm, _ = SCM_DIRS.find do |scm,dir|
                    File.directory?(File.join(@root,dir))
                  end

        @git_submodules = File.file?(File.join(@root,'.gitmodules'))
      end

      #
      # Specifies if the repository is a Git repository.
      #
      # @return [Boolean]
      #
      def git?
        @scm == :git
      end

      #
      # Specifies whether the repository has Git submodules.
      #
      # @return [Boolean]
      #
      def git_submodules?
        @git_submodules
      end

      #
      # Specifies if the repository is a Mercurial repository.
      #
      # @return [Boolean]
      #
      def hg?
        @scm == :hg
      end

      #
      # Specifies if the repository is a SubVersion repository.
      #
      # @return [Boolean]
      #
      def svn?
        @scm == :svn
      end

    end
  end
end
