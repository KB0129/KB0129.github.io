---
layout: default
title: Home
---

<div style="text-align: center; margin: 2rem 0 4rem 0;">
  <h1 style="font-size: 3.5rem; margin-bottom: 1rem; font-weight: 900; letter-spacing: -0.05em; font-family: 'Lato', sans-serif;">Dev Log</h1>
  <p style="font-size: 1.1rem; color: #666; font-family: 'Lato', sans-serif; margin-bottom: 2.5rem; font-weight: 400; letter-spacing: 0.05em;">
    SOFTWARE ENGINEERING & TECHNOLOGY
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

<div style="border-top: 3px solid #000; padding-top: 3rem; margin-top: 3rem;">
  <h2 style="font-family: 'Lato', sans-serif; font-weight: 700; font-size: 2rem; margin-bottom: 2.5rem; text-align: center; letter-spacing: -0.02em;">Recent Posts</h2>

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

  <div style="text-align: center; margin-top: 3.5rem; padding-top: 2rem; border-top: 1px solid #DDDDDD;">
    <a href="{{ '/posts/' | relative_url }}" style="color: #0051C3; font-family: 'Lato', sans-serif; font-weight: 700; text-decoration: none; font-size: 0.9rem; text-transform: uppercase; letter-spacing: 0.1em; padding: 0.75rem 2rem; border: 2px solid #0051C3; display: inline-block; transition: all 0.3s ease;">
      View All Posts →
    </a>
  </div>
</div>
