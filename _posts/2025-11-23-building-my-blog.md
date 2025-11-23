---
title: "Building a GitHub Blog from Scratch: A Step-by-Step Guide"
date: 2025-11-23
categories:
  - Tutorial
tags:
  - GitHub Pages
  - Jekyll
  - Minimal Mistakes
---

Building a personal blog is a great way to share knowledge and build your online presence. In this guide, I'll walk you through the entire process of creating a blog using **GitHub Pages** and **Jekyll**, starting from absolutely nothing.

We'll be using the [Minimal Mistakes](https://mmistakes.github.io/minimal-mistakes/) theme, which is a popular, clean, and responsive theme for Jekyll.

## Prerequisites

Before we begin, make sure you have:
1. A [GitHub account](https://github.com/).
2. [Git](https://git-scm.com/) installed on your computer.
3. A basic understanding of using the terminal.

---

## Step 1: Create a GitHub Repository

1. Log in to GitHub and create a new repository.
2. Name the repository `username.github.io`, where `username` is your actual GitHub username. 
   > **Important**: This exact naming convention is required for GitHub Pages to work automatically.
3. Make it **Public**.
4. Check "Initialize this repository with a README".
5. Click **Create repository**.

## Step 2: Clone the Repository Locally

Open your terminal and clone the repository to your local machine:

```bash
git clone https://github.com/username/username.github.io.git
cd username.github.io
```

*(Replace `username` with your actual GitHub username)*

## Step 3: Install Jekyll and Dependencies

We need to set up a `Gemfile` to manage our Ruby dependencies.

1. Create a file named `Gemfile` in the root of your repository with the following content:

   ```ruby
   source "https://rubygems.org"

   gem "github-pages", group: :jekyll_plugins
   ```

2. Install the dependencies. Run this command in your terminal:

   ```bash
   bundle install
   ```

   > **Note for Mac Users (M1/M2)**: If you encounter architecture errors, try running:
   > ```bash
   > arch -x86_64 bundle install
   > ```

## Step 4: Configure the Blog

Create a `_config.yml` file in the root directory. This is the heart of your blog's configuration.

Here is a basic configuration to get you started with the Minimal Mistakes theme:

```yaml
title: "My Awesome Blog"
author:
  name: "Your Name"
  bio: "Software Engineer"
  avatar: "/assets/images/profile.png" # We'll add this later
description: "A blog about tech and life."
url: "https://username.github.io" # Replace with your URL

# Build settings
remote_theme: mmistakes/minimal-mistakes
plugins:
  - jekyll-feed
  - jekyll-sitemap
```

## Step 5: Create Your First Post

Jekyll looks for blog posts in a `_posts` directory.

1. Create a folder named `_posts`.
2. Inside `_posts`, create a file named `2025-11-23-hello-world.md`. The filename format `YYYY-MM-DD-title.md` is strictly enforced.
3. Add the following content:

   ```markdown
   ---
   title: "Hello World"
   date: 2025-11-23
   categories:
     - General
   ---

   Welcome to my new blog! This is my very first post.
   ```

## Step 6: Run Locally

Now, let's see your blog in action!

Run the following command:

```bash
bundle exec jekyll serve
```

> **Mac M1/M2 Users**:
> ```bash
> arch -x86_64 bundle exec jekyll serve
> ```

Open your browser and go to `http://127.0.0.1:4000`. You should see your new blog running locally!

## Step 7: Adding an About Page

1. Create a folder named `_pages`.
2. Inside `_pages`, create `about.md`:

   ```markdown
   ---
   permalink: /about/
   title: "About Me"
   ---

   Hi, I'm a developer passionate about...
   ```

3. To make it appear in the navigation, you might need to adjust `_config.yml` or add navigation data, but Minimal Mistakes often picks up pages automatically or via `_data/navigation.yml`.

## Step 8: Deploy to GitHub

Once you are happy with your changes, it's time to go live.

```bash
git add .
git commit -m "Initial blog setup"
git push origin main
```

Wait a minute or two, then visit `https://username.github.io`. Your blog is now live for the world to see!

---

## Troubleshooting

- **404 Error**: Make sure your repository is named exactly `username.github.io`.
- **Ruby Errors**: Ensure you have a compatible Ruby version installed. Using `rbenv` or `rvm` is recommended.

Happy blogging!
