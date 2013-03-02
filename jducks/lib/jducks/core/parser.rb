require 'yaml'

module JDucks
  module Core
    class Parser

      def initialize data = nil
        @data = data || {
          :function=>{},
          :class=>{}
        }
        @dependencies = {}
      end

      def parse_files files = []
        files.each do |dir|
          parse_dir dir
        end
        @data
      end

      def parse_dir dir
        Dir.glob(dir).each do |path|
           if File.file? path
             parse_file path
           elsif File.directory? path
             read_dir path
           end
        end
        @data
      end

      def parse_file path
        file = open path
        parse file.read
      end

      def parse src
        blocks = src.scan /\/\*\*\*(.+?)\*\*\*\//m
        
        current_class = nil

        blocks.each_with_index do |block, index|
          str = block[0]

            yml = YAML.load str#.gsub /^\s{2}/, ""
            if yml["class"]
              current_class = yml["class"]
            end
            resource_type = [:class, :function, :method].find {|r| yml[r.to_s]}
            resource = yml[resource_type.to_s]

            if resource_type == :class
              yml["self_methods"] ||= []
            elsif resource_type == :method
              (@data[:class][current_class]["self_methods"] ||= []).push(yml)
            end

            complete_name = %~#{yml["namespace"]+"." if yml["namespace"]}#{resource}~
            yml["resource_name"] = resource
            yml["complete_resource_name"] = complete_name

            if(dependencies = @dependencies[complete_name])
              yml["dependency_of"] = dependencies
            else
              @dependencies[complete_name] = yml["dependency_of"] = []
            end

            yml["dependencies"].each do |dependency|
              (@dependencies[dependency] ||= []) << complete_name
            end if yml["dependencies"]

            @data[resource_type][complete_name] = yml unless resource_type == :method
          # end
        end

        @data

      end

    end
  end
end