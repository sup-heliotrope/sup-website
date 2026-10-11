---
---
<!DOCTYPE html>
<html>
  <head>
    <meta charset='utf-8'>
    <link rel="stylesheet" type="text/css" href="/stylesheets/stylesheet.css" media="screen" />
    <link rel="icon" href="data:image/png;base64,iVBORw0KGgo=" />
    <title>{{ page.title | default: "sup" }}</title>
    <meta name="viewport" content="width=device-width" />
{%- if page.atom_feed %}
    <link rel="alternate" type="application/atom+xml" href="{{ page.atom_feed }}" />
{%- endif %}
  </head>
  <body>
{% include header.html %}
    {{ content }}


  </body>
</html>

