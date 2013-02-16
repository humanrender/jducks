require "cgi"
require "nokogiri"

module JDucks
  module Core
    class HTMLTemplate < JDucks::Core::Template

      def initialize dir
        super dir, ".html", ".html.erb"
      end

      def build_template template
        ERB.new(template, 0, "%<>", "@output").result(@template_binding.instance_eval { binding })
      end

      def content_with_layout 
        template = ERB.new(file_content("layout"), 0, "%<>", "@output");
        bind = @template_binding.instance_eval { binding }
        template.result(bind)
      end

      def tidy html
        html
      end

    end
  end
end



