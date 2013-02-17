module JDucks
  module Helpers
    module UrlHelper
      def url_for resource
        path = if resource.class == String
          resource
        else
          resource["complete_resource_name"]
        end
        relative_path_for %~#{path.gsub(/\./,"/")}.html~
      end
    end
  end
end