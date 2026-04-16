# Content Management Harness

A validation and management system for your blog that enforces compliance rules and authentic writing style.

## 🎯 What This Does

This harness helps you:
1. **Prevent security issues**: Blocks posts with staging URLs, API keys, internal info
2. **Maintain authentic voice**: Warns about LLM-generated or overly corporate language
3. **Manage posts easily**: CLI tools for creating, validating, and publishing

## 🚀 Quick Start

### Option 1: From project root
```bash
./.harness/harness.sh help
```

### Option 2: Create an alias (recommended)
```bash
# Add to your ~/.bashrc or ~/.zshrc:
alias harness="$PWD/.harness/harness.sh"

# Then use:
harness create "My Post Title"
harness validate _drafts/my-post.md
harness publish _drafts/my-post.md
```

## 📝 Workflow

### 1. Create a new post
```bash
./.harness/harness.sh create "Building a Chat App"
# Creates: _drafts/2026-04-16-building-a-chat-app.md
```

### 2. Write your content
Edit the file in your favorite editor. The template guides you to write in your authentic voice.

### 3. Validate before publishing
```bash
./.harness/harness.sh validate _drafts/2026-04-16-building-a-chat-app.md
```

This checks for:
- ❌ **Security issues** (blocking): Sensitive keywords, internal URLs, credentials
- ⚠️ **Writing style** (warnings): LLM phrases, promotional language
- ℹ️ **Info** (suggestions): Personal voice, UiPath mention count

### 4. Publish
```bash
./.harness/harness.sh publish _drafts/2026-04-16-building-a-chat-app.md
# Moves to _posts/ directory
```

### 5. Deploy
```bash
git add _posts/
git commit -m "Add new post: Building a Chat App"
git push
```

## 🛡️ What Gets Blocked (Errors)

These issues **prevent publication**:

### Security Issues
- ❌ Sensitive keywords: `staging`, `internal`, `confidential`
- ❌ Internal URLs: `*.internal.uipath.com`, `staging.uipath.com`
- ❌ Credentials: API keys, tokens, passwords
- ❌ Internal code patterns: Environment variables with actual values

### Frontmatter Issues
- ❌ Missing required fields: `layout`, `title`, `date`, `categories`, `excerpt`

## ⚠️ What Gets Warned (Warnings)

These issues **show warnings** but don't block:

### LLM-Style Writing
- "it's worth noting"
- "leverage the power of"
- "seamlessly integrate"
- "robust solution"
- "cutting-edge"

### Overly Promotional Language
- "UiPath's industry-leading platform..."
- "revolutionary automation..."
- Too many UiPath mentions (>10 per post)

### Impersonal Voice
- "one should..."
- "users can..."
- "it is recommended..."

## ✅ What's Encouraged

### Personal Voice
- ✅ "I tried..."
- ✅ "I found..."
- ✅ "Here's what worked for me..."
- ✅ "I spent 2 hours debugging..."

### Technical Focus
- ✅ Code examples with your own comments
- ✅ Real problems you faced
- ✅ Actual solutions that worked

## 📚 Style Guide

For detailed examples, see [style-guide.md](rules/style-guide.md)

### Good Example (✅)
```markdown
I needed to build a chat interface for a client project. I tried 
a few SDK options and went with UiPath's Conversational Agent SDK 
because it had TypeScript support and WebSocket handling built in.

Setup took about 2 hours. Here's what tripped me up:
```

### Bad Example (❌)
```markdown
In today's digital landscape, UiPath's cutting-edge Conversational 
Agent SDK provides a robust, enterprise-grade solution for seamlessly 
integrating AI-powered conversational experiences. It's worth noting 
that this innovative platform leverages the power of...
```

## 🔧 Configuration

### Validation Rules
Edit `.harness/rules/compliance-rules.yml` to customize:
- Add/remove sensitive keywords
- Adjust UiPath mention limits
- Change severity levels
- Add custom patterns

### Post Templates
Edit `.harness/templates/post-template.md` to change the default structure.

## 🧪 Testing the Validator

Validate an existing post to see how it works:

```bash
./.harness/harness.sh validate _posts/2026-03-23-uipath-coded-apps.md
```

## 📦 Dependencies

The validator requires Node.js. Install if needed:

```bash
# Check if installed
node --version

# If not installed, download from:
# https://nodejs.org/
```

The validator also needs the `js-yaml` package:

```bash
cd .harness/scripts
npm install js-yaml
```

## 🎯 Real-World Example

### Before (❌ Would be flagged)
```markdown
---
title: "Enterprise Automation"
date: 2026-04-16
---

UiPath's cutting-edge platform provides a robust solution for 
enterprise automation. It's worth noting that by leveraging the 
power of our staging environment at staging.uipath.com, users 
can seamlessly integrate...

API_KEY=sk_live_123456789
```

**Issues**:
- ❌ Sensitive keyword: "staging"
- ❌ Internal URL: "staging.uipath.com"
- ❌ Exposed credential: "API_KEY"
- ⚠️ LLM phrases: "cutting-edge", "it's worth noting", "leverage"
- ⚠️ Promotional: "UiPath's... robust solution"

### After (✅ Would pass)
```markdown
---
layout: default
title: "Building My First UiPath Automation"
date: 2026-04-16
categories: [UiPath, Tutorial]
excerpt: "I spent a weekend learning UiPath automation. Here's what I built and what I learned."
---

I wanted to automate my weekly report generation, so I tried 
building my first UiPath workflow.

Here's what I learned after 6 hours of trial and error:

## The Problem
My reports took 2 hours every Friday...
```

**Why it passes**:
- ✅ No security issues
- ✅ Personal voice ("I wanted", "I learned")
- ✅ No LLM-style phrases
- ✅ Technical focus, not promotional

## 🚨 Emergency: Bypass Validation

If you absolutely need to bypass validation (not recommended):

```bash
# Manually move to _posts without validation
mv _drafts/my-post.md _posts/
```

But remember: **Your manager already warned you once!** The harness is here to protect you.

## 📊 Audit Trail

Validation results can be logged:

```bash
./.harness/harness.sh validate _drafts/my-post.md | tee .harness/logs/$(date +%Y-%m-%d).log
```

## 🤝 Contributing

To add new validation rules:

1. Edit `.harness/rules/compliance-rules.yml`
2. Test with: `./.harness/harness.sh validate <test-file>`
3. Update documentation

## 📖 Learn More

- [Architecture](ARCHITECTURE.md) - System design and components
- [Style Guide](rules/style-guide.md) - Writing examples and tips
- [Compliance Rules](rules/compliance-rules.yml) - Full rule definitions

---

**Remember**: This harness is your safety net. It helps you write authentic, compliant content without worrying about accidentally leaking sensitive information. 🛡️
