require "./jducks/lib/jducks/core/html_template.rb"
module JDucks
  module Templates
    class HtmlTemplate < JDucks::Core::HTMLTemplate
      files "stylesheets/"
    end
  end
end