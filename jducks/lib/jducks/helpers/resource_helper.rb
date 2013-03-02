module JDucks
  module Helpers
    module ResourceHelper

      def get_sitemap resources

        sitemap = {
          :functions=>{},
          :classes=>{},
          :namespaces=>{}
        }

        resources.reject{|key, resources| key.to_s == "dependencies"}.each do |group, items|
          items.each do |item_name, data|
            begin
              ns = if data["namespace"]
                build_namespace(sitemap, data["namespace"])
              end
              if data["function"]
                (ns || sitemap[:functions])[data["function"]] = data
              elsif data["class"] || data["method"]
                (ns || sitemap[:classes])[data["class"]] = data
              end
            rescue Exception => e
              debugger
              e
            end
          end
        end

        sitemap

      end #get_sitemap

      def build_namespace sitemap, namespace
        namespace.split(".").inject(sitemap) do |sum, name|
          sum[name] ||= {}
          sum[name]
        end
      end

      def return_type returns
        return "void" if !returns
        type = (returns || "").match(/\((.+?)\)/)
        return type[1] if type
        returns
      end

    end
  end
end