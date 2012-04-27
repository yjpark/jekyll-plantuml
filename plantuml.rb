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

      site = context.registers[:site]
      folder = "/images/plantuml/"
      cmd = "mkdir -p " + site.dest + folder
      puts "Create PlantUML image path:\n\t" + cmd
      stdout, stderr, status = Open3.capture3(cmd)
      puts "status -->\t" + status + "\n" + "stdout -->\t" + result + "\n" + "stderr -->\t" + error

      filepath = folder + Digest::MD5.hexdigest(code) + ".png"
      plantuml_jar = File.expand_path(site.config['plantuml_jar'])
      cmd = "java -jar " + plantuml_jar + " -pipe > " + File.join(site.dest, filepath)
      puts "Generate PlantUML image:\n\t" + cmd
      stdout, stderr, status = Open3.capture3(cmd, :stdin_data=>code)
      puts "status -->\t" + status + "\n" + "stdout -->\t" + result + "\n" + "stderr -->\t" + error

      source = "<figure class='code'>"
      source += "<img src='" + filepath + "'>"
      source += "</figure>"
      source
    end
  end
end

Liquid::Template.register_tag('plantuml', Jekyll::PlantUMLBlock)
