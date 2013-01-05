require 'singleton'

module JDucks
  module Core
    class Conf
      include Singleton

      attr_accessor :files, :template, :dir, :layout, :project_name

      def initialize
        @template ||= "basic-html"
        @dir ||= "docs"
        @project_name ||= "jducks"
      end

    end
  end
end