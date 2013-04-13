require 'fileutils'
require "ostruct"
require "erb"
require_relative "../helpers/path_helper"
require_relative "../helpers/rendering_helper"
require_relative "../helpers/capturing_helper"
require_relative "../helpers/url_helper"
require_relative "../helpers/resource_helper"
require_relative "../helpers/template_helper"

module JDucks
  module Core

    class Template
      
      attr_accessor :template_dir, :tmpl_ext, :file_ext, :template_binding

      def self.get_template_class template
        template = template.split(/\W+?/).collect(&:capitalize).join + "Template"
        begin
          Object.const_get("JDucks").const_get("Templates").const_get(template)
        rescue
          nil
        end
      end

      @@files = []

      def self.files *files
        @@files.concat files #self._files.concat(files)
      end

      def initialize dir, file_ext, tmpl_ext
        @dir = dir
        @file_ext = file_ext
        @tmpl_ext = tmpl_ext
        @template_binding = nil
        @data = nil
      end

      def build data
        copy_files
        @data = data
        data[:function].each do |page_name, properties|
          render_function_page page_name, properties
        end
        data[:class].each do |page_name, properties|
          render_class_page page_name, properties
        end
      end

      def copy_files
        dir = File.expand_path @dir
        FileUtils.rm_rf dir
        FileUtils.mkpath dir
        @@files.each do |file|
          FileUtils.cp_r "#{template_dir}/#{file}", "#{@dir}/#{file}"
        end
      end

      def render_function_page page_name, locals
        self.build_page_with_template page_name, "templates/function", locals
      end

      def render_class_page page_name, locals
        self.build_page_with_template page_name, "templates/class", locals
      end

      def build_page_with_template page_name, tmpl, locals
        page_name = page_name+@file_ext
        tmpl = file_content tmpl
        dir_path = @dir+"#{"/"+locals["namespace"].gsub(".", "/") if locals["namespace"]}"
        file_path = dir_path+"/"+(page_filename locals["resource_name"])

        @template_binding = TemplateBinding.new locals
        @template_binding.template = self
        @template_binding.file_path = file_path
        @template_binding.parsed_items = @data

        FileUtils.mkpath dir_path unless File.exists? dir_path
        File.open(file_path, 'w') { |file| 
          output = ""
          content = content_with_layout do
            output.concat %~#{@template_binding.output}~
            build_template tmpl
          end
          file.write( tidy output+content )  
        }
        page_name
      end

      def file_content file_name
        File.new("#{@template_dir}/#{file_name}#{@tmpl_ext}").read
      end

      def page_filename page_name
        page_name+@file_ext
      end

      def build_template template
        template
      end

      def content_with_layout locals, &block
        yield
      end

      def tidy content
        content
      end

    end

    class TemplateBinding < OpenStruct
      include JDucks::Helpers::PathHelper
      include JDucks::Helpers::RenderingHelper
      include JDucks::Helpers::CapturingHelper
      include JDucks::Helpers::UrlHelper
      include JDucks::Helpers::ResourceHelper
      include JDucks::Helpers::TemplateHelper
      attr_accessor :output
    end

  end
end

