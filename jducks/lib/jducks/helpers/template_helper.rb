module JDucks
  module Helpers
    module TemplateHelper

      def function_declaration resource_name, arguments
        %~function #{resource_name}(#{arguments_line arguments})~
      end

      def arguments_line arguments
        line = (arguments || {}).map do |name, properties|
          defaults = properties[:default] != "undefined" ? properties[:default] : nil
          %~#{name}#{" /*#{defaults}*/" if defaults}~
        end.join(", ")
        line
      end
      
    end
  end
end