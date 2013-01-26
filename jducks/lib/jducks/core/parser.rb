require 'yaml'

module JDucks
  module Core
    class Parser

      def initialize data = nil
        @data = data || {
          :function=>{},
          :class=>{}
        }
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
          if current_class && str.match(Regexp.new(%~\\#{current_class}~))
            current_class = nil
          else
            yml = YAML.load str#.gsub /^\s{2}/, ""
            if yml["class"]
              current_class = yml["class"]
            end
            resource_type = [:class, :function, :method].find {|r| yml[r.to_s]}
            resource = yml[resource_type.to_s]
            if resource_type == :class
              yml["methods"] ||= []
            end
            complete_name = %~#{yml["namespace"]+"." if yml["namespace"]}#{resource}~
            yml["resource_name"] = resource
            yml["complete_resource_name"] = complete_name
            @data[resource_type][complete_name] = yml
          end
        end

        @data

      end

    end
  end
end