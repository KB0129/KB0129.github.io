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
      <h3 class="post-title">
        <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
      </h3>
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
          {{ post.excerpt | strip_html | truncatewords: 40 }}
        </div>
      {% endif %}
    </article>
  {% endfor %}
</div>

<div class="view-all-link">
  <a href="{{ '/posts/' | relative_url }}">View All Posts →</a>
</div>
