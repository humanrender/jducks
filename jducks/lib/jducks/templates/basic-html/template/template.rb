require "./jducks/lib/jducks/core/html_template.rb"
module JDucks
  module Templates
    class BasicHtml < JDucks::Core::HTMLTemplate

      def self.this_file
        __FILE__
      end

    end
  end
end