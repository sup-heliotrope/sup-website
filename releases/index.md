---
title: sup releases
layout: wide_page
atom_feed: /releases/index.atom
---
## Releases

For release notes, refer to
[History.txt](../git/sup/file/History.txt.html)
in the Sup source code.

{% for release in site.data.releases -%}
* [sup-{{ release.version }}.gem](sup-{{ release.version }}.gem) {{ release.date | date: "%d %B %Y" }}  
  SHA256: `{{ release.sha256 }}`
{% endfor %}
