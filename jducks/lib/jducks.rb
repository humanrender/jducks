require "debugger"
require 'fileutils'

require_relative "jducks/core/conf"
require_relative "jducks/core/parser"
require_relative "jducks/core/template"

module JDucks
  def self.build    
    conf = JDucks::Core::Conf.instance

    FileUtils.rm_rf conf.dir
    
    if conf.files.class != Array
      conf.files = [conf.files]
    end

    conf.docs_dir ||= conf.dir

    parser = JDucks::Core::Parser.new
    template = self.build_template conf

    data = parser.parse_files conf.files
    template.build data
  end

  def self.conf
    yield JDucks::Core::Conf.instance
  end

  # protected

  def self.build_dir dir
    Dir.mkdir(dir) unless File.exists?(dir)
  end

  def self.build_template conf
    conf_dir = "./"+conf.dir
    output_dir = "./"+conf.docs_dir
    template_dir = "#{conf_dir}/#{conf.template}"
    unless File.exists? template_dir
      self.build_dir conf.dir

      template_path = File.dirname(__FILE__)+"/jducks/templates/"+conf.template
      copy_template_files template_path, template_dir
    end

    require template_dir+"/template.rb"
    template_class = JDucks::Core::Template.get_template_class(conf.template)
    template = template_class.new output_dir
    template.template_dir = template_dir
    template
  end

  def self.copy_template_files template_dir, dir
    FileUtils.cp_r template_dir, dir
  end

end