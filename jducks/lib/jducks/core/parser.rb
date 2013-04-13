require 'yaml'
require_relative "./file"

module JDucks
  module Core
    class Parser

      def initialize data = nil
        @data = data || {
          :function=>{},
          :class=>{},
          :sources=>{}
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
        #file = open path
        parse SourceFile.new(path) #file.read, path
      end

      def parse file #src, file_path = nil
        src = file.src
        blocks = src.scan /\/\*\*\*(.+?)\*\*\*\//m
        
        current_class = nil
        @data[:sources][file.path] = {
          :path => file.path,
          :source => src
        }

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

            yml["arguments"] = parse_arguments yml["arguments"]
            

            yml["source"] = file.path
            yml["declared_at"] = file.line_of block[0]

            yml["dependencies"].each do |dependency|
              (@dependencies[dependency] ||= []) << complete_name
            end if yml["dependencies"]

            @data[resource_type][complete_name] = yml unless resource_type == :method
          # end
        end

        @data

      end

      def parse_arguments arguments = {}
        parsed_args = {}
        (arguments || {}).each do |arg, desc|

          parsed_args[arg] = case desc
            when String
              desc_to_hash = {:required=> false, :default=>"undefined"}
              desc = desc.strip

              while desc.match /^(\((required|default:.+?|.+?)\))+/ #/^\((required|default:.+?|.+?)\)*/
                args = $~

                if args[1].match(/required/)
                  desc_to_hash[:required] = true 
                elsif args[1].match(/\(default:\s*(.+?)\)/)
                  desc_to_hash[:default] = $~[1] 
                else
                  
                  desc_to_hash[:type] = args[2]
                end
                desc = desc.gsub(args[1], "").strip
              end
              desc_to_hash[:description] = desc
              desc_to_hash
            when Hash
              desc
            else
              {}
            end


        end
        parsed_args
      end

    end
  end
end