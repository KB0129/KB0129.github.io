---
layout: default
title: Home
---

<div class="home-hero">
  <div class="profile-image-wrapper">
    <img src="/assets/images/pinn-profile.png" alt="Kyungbin Lee">
  </div>
  <h1 class="hero-title">Dev Log</h1>
  <p class="hero-subtitle">
    Exploring software engineering and technology
  </p>
  <div class="home-buttons">
    <a href="{{ '/posts/' | relative_url }}">View Posts</a>
    <a href="{{ '/about/' | relative_url }}">About Me</a>
  </div>
</div>

<div class="section-divider"></div>

<h2 class="section-header">Recent Posts</h2>

{% assign recent_posts = site.posts | sort: 'date' | reverse | limit: 5 %}

<div class="post-list">
{% for post in recent_posts %}
  <article class="post-item">
    <div class="post-item-header">
      {% if post.categories.size > 0 %}
        <div class="post-item-tags">
          {% for category in post.categories limit:3 %}
            <span class="post-item-tag">{{ category }}</span>
          {% endfor %}
        </div>
      {% endif %}
      <time class="post-item-date" datetime="{{ post.date | date_to_xmlschema }}">
        {{ post.date | date: "%b %d, %Y" }}
      </time>
    </div>

    <h3 class="post-title">
      <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
    </h3>

    {% if post.excerpt %}
      <div class="post-excerpt">
        {{ post.excerpt | strip_html | truncatewords: 40 }}
      </div>
    {% endif %}

    <div class="post-item-footer">
      <a href="{{ post.url | relative_url }}" class="read-more-link">Read article →</a>
    </div>
  </article>
{% endfor %}
</div>

<div class="view-all-link">
  <a href="{{ '/posts/' | relative_url }}">View All Posts →</a>
</div>
