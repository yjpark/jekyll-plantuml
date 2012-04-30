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

Configuration
-------------
You need to download the plantuml.jar file from http://plantuml.sourceforge.net/download.html

In your \_config.xml, setup plantuml\_jar to the downloaded jar file, e.g.

```
plantuml_jar: ../_lib/plantuml.jar
plantuml_background_color: "#f8f8f8"
```

The plantuml_background_color is optional, which will change the background of the generated diagram.

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
