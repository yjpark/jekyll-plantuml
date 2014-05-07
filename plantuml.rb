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
require 'fileutils'

module Jekyll

  class PlantUMLBlock < Liquid::Block
    def render(context)
      site = context.registers[:site]
      config = site.config['plantuml']
      code = @nodelist.join

      puts "\nPlantUML configuration:"
      if !config['background_color'].nil?
        background_color = "skinparam backgroundColor " + config['background_color']
        puts "\tbackground_color = " + background_color
        code = background_color + code
      end

      tmproot = File.expand_path(config['tmp_folder'])
      folder = "/images/plantuml/"
      folderpath = tmproot + folder
      if !File.exist?(folderpath)
        FileUtils::mkdir_p folderpath
        puts "Create PlantUML image folder: " + folderpath + "\n"
      end

      dotcmd = ""
      if !config['dot_exe'].nil?
        dotpath = File.expand_path(config['dot_exe'])
        if File.exist?(dotpath)
          puts "Use graphviz dot: " + dotpath + "\n"
          dotcmd = " -graphvizdot " + dotpath
        end
      end
      
      filename = Digest::MD5.hexdigest(code) + ".png"
      filepath = tmproot + folder + filename
      if File.exist?(filepath)
        puts "PlantUML image already exist: " + filepath + "\n"
      else
        plantuml_jar = File.expand_path(config['plantuml_jar'])
        cmd = "java -Djava.awt.headless=true -jar " + plantuml_jar + dotcmd + " -pipe > " + filepath
        result, status = Open3.capture2e(cmd, :stdin_data=>code)
        puts filepath + " -->\t" + status.inspect() + "\t" + result
      end

      site.static_files << Jekyll::StaticFile.new(site, tmproot, folder, filename)

      source = "<img src='" + folder + filename + "'>"
    end
  end
end

Liquid::Template.register_tag('plantuml', Jekyll::PlantUMLBlock)
