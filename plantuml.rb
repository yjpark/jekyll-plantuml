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
      puts code

      site = context.registers[:site]
      folder = "/images/plantuml/"
      filepath = folder + Digest::MD5.hexdigest(code) + ".png"
      plantuml_jar = File.expand_path(site.config['plantuml_jar'])
      cmd = "java -jar " + plantuml_jar + " -pipe > " + File.join(site.dest, filepath)
      puts "Generate PlantUML image: \n\t" + cmd
      exec "mkdir -p " + site.dest + folder
      stdin, stdout, stderr = Open3.popen3('java -jar plantuml.jar -pipe > somefile.png ')
      stdin.puts(code)
      stdin.close()
      result = stdout.gets
      puts "\t -> " + result

      source = "<figure class='code'>"
      source += "<img src='" + filepath + "'>"
      source += "</figure>"
      source
    end
  end
end

Liquid::Template.register_tag('plantuml', Jekyll::PlantUMLBlock)
