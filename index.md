---
layout: default
title: Home
nav_order: 1
---

<div style="text-align: center; margin: 3rem 0 4rem 0;">
  <h1 style="font-size: 3rem; margin-bottom: 0.5rem; font-weight: 700; letter-spacing: -0.03em;">Dev Log</h1>
  <p style="font-size: 1.2rem; color: #666; font-family: var(--font-family-sans); margin-bottom: 2rem;">
    Software Engineering & Technology
  </p>
  <div class="home-buttons" style="display: flex; gap: 2rem; justify-content: center; margin-top: 2rem; font-family: var(--font-family-sans);">
    <a href="{{ '/posts/' | relative_url }}" style="padding: 0.75rem 2rem; background-color: #000; color: #fff; text-decoration: none; font-weight: 600; text-transform: uppercase; letter-spacing: 0.05em; font-size: 0.9rem; border-radius: 2px; transition: all 0.2s;">
      View Posts
    </a>
    <a href="{{ '/about/' | relative_url }}" style="padding: 0.75rem 2rem; background-color: #fff; color: #000; text-decoration: none; font-weight: 600; text-transform: uppercase; letter-spacing: 0.05em; font-size: 0.9rem; border: 2px solid #000; border-radius: 2px; transition: all 0.2s;">
      About Me
    </a>
  </div>
</div>

<div style="border-top: 2px solid #000; padding-top: 3rem;">
  <h2 style="font-family: var(--font-family-sans); font-weight: 700; font-size: 1.8rem; margin-bottom: 2rem; text-align: center;">Recent Posts</h2>

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
    <a href="{{ '/posts/' | relative_url }}" style="color: #0274B6; font-family: var(--font-family-sans); font-weight: 600; text-decoration: none; font-size: 1rem; text-transform: uppercase; letter-spacing: 0.05em; border-bottom: 2px solid #0274B6; padding-bottom: 0.25rem;">
      View All Posts →
    </a>
  </div>
</div>
