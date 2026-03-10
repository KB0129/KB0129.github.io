---
layout: default
title: "Posts"
permalink: /posts/
---

# All Posts

{% assign sorted_posts = site.posts | sort: 'date' | reverse %}

<div class="post-list">
{% for post in sorted_posts %}
  <article class="post-item">
    <h2 class="post-title">
      <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
    </h2>
    <div class="post-meta">
      <time datetime="{{ post.date | date_to_xmlschema }}">
        {{ post.date | date: "%B %d, %Y" }}
      </time>
      {% if post.categories.size > 0 %}
        <span class="separator">•</span>
        <span class="categories">
          {% for category in post.categories %}
            {{ category }}{% unless forloop.last %}, {% endunless %}
          {% endfor %}
        </span>
      {% endif %}
    </div>
    {% if post.excerpt %}
      <div class="post-excerpt">
        {{ post.excerpt | strip_html | truncatewords: 50 }}
      </div>
    {% endif %}
  </article>
{% endfor %}
</div>
