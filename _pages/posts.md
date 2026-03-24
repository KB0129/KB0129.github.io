---
layout: default
title: "Posts"
permalink: /posts/
---

<div class="posts-header">
  <h1 class="posts-page-title">📝 All Posts</h1>
  <p class="posts-page-subtitle">{{ site.posts.size }} articles about software engineering and technology</p>
</div>

{% assign sorted_posts = site.posts | sort: 'date' | reverse %}

<div class="posts-grid">
{% for post in sorted_posts %}
  <article class="post-card">
    <a href="{{ post.url | relative_url }}" class="post-card-link">
      <div class="post-card-header">
        {% if post.categories.size > 0 %}
          <div class="post-tags">
            {% for category in post.categories limit:3 %}
              <span class="post-tag">{{ category }}</span>
            {% endfor %}
          </div>
        {% endif %}
        <time class="post-date" datetime="{{ post.date | date_to_xmlschema }}">
          {{ post.date | date: "%b %d, %Y" }}
        </time>
      </div>

      <h2 class="post-card-title">{{ post.title }}</h2>

      {% if post.excerpt %}
        <p class="post-card-excerpt">
          {{ post.excerpt | strip_html | truncatewords: 30 }}
        </p>
      {% endif %}

      <div class="post-card-footer">
        <span class="read-more">Read article →</span>
      </div>
    </a>
  </article>
{% endfor %}
</div>
