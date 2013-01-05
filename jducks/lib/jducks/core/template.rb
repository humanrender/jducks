require "ostruct"
require "erb"

module JDucks
  module Core

    class Template
      
      attr_reader :template_dir

      def self.get_template_class template
        template = template.split(/\W+?/).collect(&:capitalize).join
        begin
          Object.const_get("JDucks").const_get("Templates").const_get(template)
        rescue
          nil
        end
      end

      def self.template_dir
        File.dirname(self.this_file)
      end

      def initialize dir, file_ext, tmpl_ext
        @dir = dir
        @file_ext = file_ext
        @tmpl_ext = tmpl_ext
      end

      def build data
        data[:function].each do |page_name, properties|
          render_function_page page_name, properties
        end
      end

      def render_function_page page_name, locals
        self.build_page_with_template page_name, "resources/function", locals
      end

      def build_page_with_template page_name, template, locals
        page_name = page_name+@file_ext
        template = file_content template
        dir_path = @dir+"#{"/"+locals["namespace"].gsub(".", "/") if locals["namespace"]}"
        file_path = dir_path+"/"+(page_filename locals["resource_name"])

        @template_binding = TemplateBinding.new locals
        @template_binding.file_path = file_path
        puts file_path
        FileUtils.mkpath dir_path unless File.exists? dir_path
        File.open(file_path, 'w') { |file| 
          file.write( content_with_layout(locals){build_template template, locals} )  
        }
        page_name
      end

      def file_content file_name
        File.new("#{self.class.template_dir}/#{file_name}#{@tmpl_ext}").read
      end

      def page_filename page_name
        page_name+@file_ext
      end

      def build_template template, locals
        template
      end

      def content_with_layout locals, &block
        yield
      end

    end

    class TemplateBinding < OpenStruct

    end

  end
end

