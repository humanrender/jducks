require "cgi"
module JDucks
  module Core
    class HTMLTemplate < JDucks::Core::Template

      def initialize dir
        super dir, ".html", ".html.erb"
      end

      def build_template template, locals
        ERB.new(template).result(@template_binding.instance_eval { binding })
      end

      def content_with_layout locals, &block
        ERB.new(file_content "layout").result(@template_binding.instance_eval { binding })
      end

    end
  end
end