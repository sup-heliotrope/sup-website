---
title: sup screenshots
layout: narrow_page
screenshots: 
 - /screenshots/1.4/inbox.png
 - /screenshots/1.4/search-results.png
 - /screenshots/1.4/thread-view.png
 - /screenshots/1.4/reply.png
 - /screenshots/1.4/help.png
 - /screenshots/1.4/log.png
 - /screenshots/1.4/console.png
---
{% for shot in page.screenshots %}
<a href="{{shot}}">
  <img src="{{shot}}"/>
</a>
{% endfor %}

