require 'singleton'

module JDucks
  module Core
    class Conf
      include Singleton

      attr_accessor :files, :template, :dir, :layout,
                    :project_name, :project_description, :docs_dir

      def ignored_files
      end

      def initialize
        @template = "html"
        @dir = "docs"
        @project_name = "jducks"
      end

    end
  end
end