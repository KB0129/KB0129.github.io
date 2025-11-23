---
title: "Building My GitHub Blog"
date: 2025-11-23
categories:
  - Blog
tags:
  - GitHub Pages
  - Jekyll
  - Minimal Mistakes
---

Hello! I'm **Kyungbin Lee**, a Forward Deployed Engineer at UiPath.

I decided to start this technical blog to share my journey and learnings. My first project was setting up this very blog using GitHub Pages and Jekyll. I wanted to share the process with you, explaining it in my own words so anyone can follow along.

## Why GitHub Pages?

I chose GitHub Pages because it's free, integrates perfectly with my code on GitHub, and gives me full control over the content. I'm using the [Minimal Mistakes](https://mmistakes.github.io/minimal-mistakes/) theme because it's clean, responsive, and perfect for technical writing.

## How I Built This

Here is a walkthrough of the steps I took to get this site up and running.

### 1. Configuration

First, I configured the main settings in `_config.yml`. This file controls the global settings for the site.

- **Title**: Changed to "Dev Log".
- **Author**: Updated with my name and bio.
- **URL**: Set to `https://KB0129.github.io`.

### 2. Setting Up the Environment

I used Ruby and Bundler to manage the dependencies. One interesting challenge I faced was an architecture mismatch on my Mac (M1/M2 chips often have this with older Ruby versions).

To fix it, I had to reinstall the dependencies using Rosetta:

```bash
arch -x86_64 bundle install --path vendor/bundle
```

### 3. Running Locally

Before publishing, I verified everything by running the server locally:

```bash
arch -x86_64 bundle exec jekyll serve
```

This allowed me to see the site at `http://127.0.0.1:4000` and make sure everything looked right.

### 4. Deployment

Finally, I deployed the changes to GitHub. Since this is a GitHub Pages site, all I had to do was push my code to the `master` branch.

```bash
git add .
git commit -m "Initial blog setup"
git push origin master
```

And that's it! The site is now live.

## What's Next?

I plan to use this space to write about Agentic Automation, UiPath, and other technical topics that interest me. Stay tuned!
