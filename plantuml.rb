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

  class PlantUMLFile < StaticFile
    def write(dest)
      true
    end
  end

  class PlantUMLBlock < Liquid::Block
    def render(context)
      site = context.registers[:site]

      output = super
      code = super.join

      puts "\nPlantUML configuration:"
      if !site.config['plantuml_background_color'].nil?
        background_color = "skinparam backgroundColor " + site.config["plantuml_background_color"]
        puts "\tbackgroud_color = " + background_color
        code = background_color + code
      end

      folder = "/images/plantuml/"
      cmd = "mkdir -p " + site.dest + folder
      puts "Create PlantUML image path:\n\t" + cmd
      result, status = Open3.capture2e(cmd)
      puts "  -->\t" + status.inspect() + "\t" + result

      filename = Digest::MD5.hexdigest(code) + ".png"
      plantuml_jar = File.expand_path(site.config['plantuml_jar'])
      cmd = "java -jar " + plantuml_jar + " -pipe > " + site.dest + folder + filename
      puts "Generate PlantUML image:\n\t" + cmd

      result, status = Open3.capture2e(cmd, :stdin_data=>code)
      puts "  -->\t" + status.inspect() + "\t" + result

      site.static_files << Jekyll::PlantUMLFile.new(site, site.dest, folder, filename)

      source = "<center>"
      source += "<img src='" + folder + filename + "'>"
      source += "</center>"
      source
    end
  end
end

Liquid::Template.register_tag('plantuml', Jekyll::PlantUMLBlock)
