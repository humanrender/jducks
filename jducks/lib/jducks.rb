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
    conf.template ||= :basic_html

    self.build_dir conf.dir

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
    require conf_dir+"/template/template.rb" if ready = File.exists?(conf.dir+"/template/template.rb")
    
    template_class = JDucks::Core::Template.get_template_class(conf.template)

    unless template_class
      require_relative "jducks/templates/#{conf.template}/template/template"
      template_class = JDucks::Core::Template.get_template_class(conf.template)
    end

    self.copy_template_files template_class, conf.dir+"/template" unless ready

    template_class.new conf_dir
  end

  def self.copy_template_files template_class, dir
    FileUtils.cp_r template_class.template_dir, dir
  end

end