jekyll-plantuml
===============

Background
----------
[PlantUML](http://plantuml.sourceforge.net/) is a component that allows to quickly write:
 * sequence diagram,
 * use case diagram,
 * class diagram,
 * activity diagram,
 * component diagram,
 * state diagram
 * object diagram

I really like the idea of writing UML diagram with plain text, and the syntax of it is very well designed, so I use PlantUML with trac and sphinx. After switching [Octopress](http://octopress.org/) to my blog platform, I was looking for a way to integrate PlantUML within it, though I can't find one, so I wrote this very simple jekyll plugin (Octopress is based on [Jekyll](http://jekyllrb.com/)).


Installation
------------

To use with Octopress, you need to put the `plantuml.rb` under the `plugins` folder, or you can use git's submodules to add jekyll-plantuml under `plugins` folder.

You need to download the `plantuml.jar` file from http://plantuml.sourceforge.net/download.html

If you use jekyll-plantuml to generate any UML diagrams other than sequence diagram, you have to install [Graphviz](http://www.graphviz.org/) as well. Only the `dot` command is used.

### Additional steps to install on Jekyll

jekyll-plantuml depends on Octopress's raw plugin. Copy it from [Octopress](https://github.com/imathis/octopress/tree/master/plugins) and put into Jekyll's `_plugins` folder. 

Octopress plugin folder is `plugins` while Jekyll is `_plugins`. Modify `plantuml.rb` to set correct path for `require` method.  

Configuration
-------------
Add below configurations into `_config.yml`:

```
plantuml:
  plantuml_jar: _bin/plantuml.jar     # path to plantuml jar
  tmp_folder: _plantuml               # tmp folder to put generated image files
  dot_exe: _bin/dot.exe               # [optional] path to Graphviz dot execution
  background_color: white             # [optional] UML image background color
```

Usage
-----
Just wrap the diagram text in "plantuml" block, e.g.
```
{% plantuml %}
Alice -> Bob: Authentication Request
Bob --> Alice: Authentication Response

Alice -> Bob: Another authentication Request
Alice <-- Bob: another authentication Response
{% endplantuml %}
```
