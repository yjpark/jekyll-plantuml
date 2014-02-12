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
require 'open3'
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

      code = @nodelist.join

      puts "\nPlantUML configuration:"
      if !site.config['plantuml_background_color'].nil?
        background_color = "skinparam backgroundColor " + site.config["plantuml_background_color"]
        puts "\tbackground_color = " + background_color
        code = background_color + code
      end

      folder = "/images/plantuml/"
      folderpath = site.dest + folder
      if File.exist?(folderpath)
        puts "PlantUML image path already exist.\n"
      else
        cmd = "mkdir -p " + folderpath
        puts "Create PlantUML image path:\n\t" + cmd
        result, status = Open3.capture2e(cmd)
        puts "  -->\t" + status.inspect() + "\t" + result
      end

      dotpath = site.config['plantuml_dotpath']
      puts "using dot at: " + dotpath + "\n"
      if File.exist?(dotpath)
        puts "PlantUML set dot path:" + dotpath + "\n"
        dotcmd = " -graphvizdot " + dotpath
      else 
        dotcmd = ""
      end

      filename = Digest::MD5.hexdigest(code) + ".png"
      plantuml_jar = File.expand_path(site.config['plantuml_jar'])
      filepath = site.dest + folder + filename
      if File.exist?(filepath)
        puts "PlantUML image already exist: " + filepath + "\n"
      else
        cmd = "java -jar " + plantuml_jar + " -pipe > " + filepath + dotcmd

        result, status = Open3.capture2e(cmd, :stdin_data=>code)
        puts "  -->\t" + status.inspect() + "\t" + result
      end

      site.static_files << Jekyll::PlantUMLFile.new(site, site.dest, folder, filename)

      source = "<center>"
      source += "<img src='" + folder + filename + "'>"
      source += "</center>"
      source
    end
  end
end

Liquid::Template.register_tag('plantuml', Jekyll::PlantUMLBlock)
