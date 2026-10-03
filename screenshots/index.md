---
title: sup screenshots
layout: wide_page
screenshots: 
 - /screenshots/0.0.x/search-results.png
 - /screenshots/0.0.x/thread-view.png
 - /screenshots/0.0.x/thread-view-2.png
 - /screenshots/0.0.x/reply.png
 - /screenshots/0.0.x/log.png
 - /screenshots/0.0.x/help.png
---
{% for shot in page.screenshots %}
<a href="{{shot}}">
  <img src="{{shot}}"/>
</a>
{% endfor %}

