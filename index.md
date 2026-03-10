---
layout: default
title: Home
---

<div style="text-align: center; margin: 2rem 0 4rem 0;">
  <h1 style="font-size: 3rem; margin-bottom: 1rem; font-weight: 600; letter-spacing: -0.02em; font-family: 'Crimson Pro', serif; color: #141413;">Dev Log</h1>
  <p style="font-size: 1.15rem; color: #6b6963; font-family: 'Crimson Pro', serif; margin-bottom: 2.5rem; font-weight: 400;">
    Exploring software engineering and technology
  </p>
  <div class="home-buttons">
    <a href="{{ '/posts/' | relative_url }}">
      View Posts
    </a>
    <a href="{{ '/about/' | relative_url }}">
      About Me
    </a>
  </div>
</div>

<div style="margin-top: 4rem;">
  <h2 style="font-family: 'Crimson Pro', serif; font-weight: 600; font-size: 2rem; margin-bottom: 2rem; text-align: center; letter-spacing: -0.01em; color: #141413;">Recent Posts</h2>

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

  <div style="text-align: center; margin-top: 3rem;">
    <a href="{{ '/posts/' | relative_url }}" style="color: #8b7355; font-family: 'Inter', sans-serif; font-weight: 500; text-decoration: none; font-size: 0.95rem; padding: 0.85rem 2rem; border: 1px solid #e5e3d8; border-radius: 8px; display: inline-block; transition: all 0.2s ease; background-color: transparent;">
      View All Posts →
    </a>
  </div>
</div>
