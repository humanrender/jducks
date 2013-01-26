require "cgi"
module JDucks
  module Core
    class HTMLTemplate < JDucks::Core::Template

      def initialize dir
        super dir, ".html", ".html.erb"
      end

      def build_template template
        ERB.new(template, 0, "%<>", "@output_buffer").result(@template_binding.instance_eval { binding })
      end

      def content_with_layout &block
        ERB.new(file_content("layout"), 0, "%<>", "@output_buffer").result(@template_binding.instance_eval { binding })
      end

    end
  end
end