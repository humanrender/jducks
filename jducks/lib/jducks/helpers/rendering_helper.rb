module JDucks
  module Helpers
    module RenderingHelper

      def render path, opts = {}, &block
        template_content = template.file_content "templates/#{path}"
        partial_binding = JDucks::Core::TemplateBinding.new opts[:locals]
        partial_binding.file_path = file_path
        self.send "_content_for=", {} unless _content_for
        partial_binding._content_for = _content_for
        ERB.new(template_content, 0, "%<>", "@output_buffer").result(partial_binding.instance_eval { binding })
      end

    end
  end
end