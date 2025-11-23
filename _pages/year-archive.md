---
layout: default
title: "Posts"
permalink: /posts/
nav_order: 2
---

# Posts

<ul>
  {% for post in site.posts %}
    <li>
      <a href="{{ post.url }}">{{ post.title }}</a>
      <span class="fs-2"> - {{ post.date | date_to_string }}</span>
    </li>
  {% endfor %}
</ul>
