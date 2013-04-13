module JDucks
  module Core
    class SourceFile

      attr_accessor :path, :src

      def initialize path
        @path = path
        @file = open(path)
        @src = @file.read
      end

      def line_of line
        index = @src.index line.to_s
        lines = @src[0..index].gsub(/\r\n?/, "\n").split(/\n/)
        lines.length
      end

    end
  end
end