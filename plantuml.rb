# Title: PlantUML Code Blocks for Jekyll
# Author: YJ Park (yjpark@gmail.com) 
# https://github.com/yjpark/jekyll-plantuml
# Description: Integrate PlantUML intu Jekyll and Octopress.
#
# Syntax:
# {% plantuml %}
# plantuml code
# {% endplantuml %}
#
require './plugins/raw'

module Jekyll

  class PlantUMLBlock < Liquid::Block
    def render(context)
      output = super
      code = super.join
      source = "<figure class='code'>"
      source += code
      source += "</figure>"
      source
    end
  end
end

Liquid::Template.register_tag('plantuml', Jekyll::PlantUMLBlock)
