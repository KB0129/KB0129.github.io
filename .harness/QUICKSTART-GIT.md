# Git-Integrated Harness - Quick Start

## 🎯 The Fastest Way to Publish

Three commands from start to PR:

```bash
bash harness create "My Post Title" --branch
bash harness publish _drafts/2026-04-16-my-post-title.md --push  
bash harness pr
```

Done! Your post is validated, published, committed, pushed, and has a PR open.

---

## 📋 What Each Command Does

### Command 1: Create with Branch

```bash
bash harness create "My Post Title" --branch
```

**Creates:**
- ✅ Draft file: `_drafts/2026-04-16-my-post-title.md`
- ✅ Git branch: `post/my-post-title`
- ✅ Switches to the new branch

**You then:**
- Edit the markdown file
- Write your content following the style guide

### Command 2: Publish with Push

```bash
bash harness publish _drafts/2026-04-16-my-post-title.md --push
```

**Does:**
1. ✅ Validates content (blocks if security issues)
2. ✅ Moves draft to `_posts/` directory
3. ✅ Creates Git commit: "Add new post: My Post Title"
4. ✅ Pushes to `origin/post/my-post-title`

**Blocked if:**
- ❌ Security issues detected (`staging` URLs, tokens, etc.)
- ❌ Missing required frontmatter
- ❌ File doesn't exist

**Warnings (doesn't block):**
- ⚠️ LLM-style writing detected
- ⚠️ Too many UiPath mentions
- ⚠️ Impersonal voice

### Command 3: Create PR

```bash
bash harness pr
```

**Creates:**
- ✅ GitHub Pull Request
- ✅ Title from commit message
- ✅ Pre-filled PR body with validation checklist
- ✅ Base branch: `master` (or `main`)

**Requires:**
- GitHub CLI (`gh`) installed and authenticated
- At least one commit on your feature branch
- Not on the default branch

---

## 🔥 Real Example

Let's publish a post about a bug you fixed:

```bash
# Step 1: Create
$ bash harness create "How I Fixed the WebSocket Timeout Bug" --branch

✓ Created draft: 2026-04-16-how-i-fixed-the-websocket-timeout-bug.md
ℹ Location: _drafts/2026-04-16-how-i-fixed-the-websocket-timeout-bug.md
ℹ Git branch created: post/how-i-fixed-the-websocket-timeout-bug

# Step 2: Edit
$ code _drafts/2026-04-16-how-i-fixed-the-websocket-timeout-bug.md

# (Write your post...)

# Step 3: Validate (optional but recommended)
$ bash harness validate _drafts/2026-04-16-how-i-fixed-the-websocket-timeout-bug.md

Validating: _drafts/2026-04-16-how-i-fixed-the-websocket-timeout-bug.md

ℹ️  INFO:
  • ✓ Good use of personal voice
  • ✓ UiPath mentions: 2 (within guidelines)

✅ PASSED: No issues found!

# Step 4: Publish & Push
$ bash harness publish _drafts/2026-04-16-how-i-fixed-the-websocket-timeout-bug.md --push

=== Validating before publish ===
✅ PASSED: No issues found!

✓ Published: 2026-04-16-how-i-fixed-the-websocket-timeout-bug.md

=== Committing to Git ===
✓ Committed: Add new post: How I Fixed the WebSocket Timeout Bug

=== Pushing to remote ===
✓ Pushed to origin/post/how-i-fixed-the-websocket-timeout-bug

# Step 5: Create PR
$ bash harness pr

=== Creating Pull Request ===
✓ Pull Request created!
ℹ View your PR: gh pr view --web
```

Done! Your PR is live and ready for review (or auto-deployment if you merge).

---

## 🎛️ Command Flags

### `create`

| Flag | Effect |
|------|--------|
| `--branch` or `-b` | Create Git feature branch |

```bash
# With branch
bash harness create "Post" --branch

# Without branch (just creates draft)
bash harness create "Post"
```

### `publish`

| Flag | Effect |
|------|--------|
| `--commit` or `-c` | Auto-commit after publishing |
| `--push` or `-p` | Auto-commit AND push |

```bash
# Just publish (manual commit)
bash harness publish _drafts/post.md

# Publish + commit
bash harness publish _drafts/post.md --commit

# Publish + commit + push (most common)
bash harness publish _drafts/post.md --push
```

**Note:** `--push` implies `--commit`

---

## 🚨 Common Issues

### Issue: "You have uncommitted changes"

**When:** Running `create --branch` with dirty working tree

**Solution:**
```bash
# Option 1: Commit them
git add .
git commit -m "WIP"

# Option 2: Stash them
git stash

# Option 3: Continue anyway (risky)
# The harness will ask: "Continue anyway? (y/n)"
```

### Issue: "Validation failed"

**When:** Post contains security issues

**Example:**
```bash
$ bash harness publish _drafts/post.md --push

❌ ERRORS (blocking):
  • SECURITY: Found blocked URL pattern "localhost"
  • SECURITY: Possible credential detected: "access_token"

❌ FAILED: 2 error(s) must be fixed
```

**Solution:**
1. Edit the draft
2. Remove security issues
3. Try again

### Issue: "No commits to create PR from"

**When:** Trying to create PR before pushing

**Solution:**
```bash
# Publish and push first
bash harness publish _drafts/post.md --push

# Then create PR
bash harness pr
```

### Issue: "GitHub CLI (gh) is not installed"

**Solution:**

**Mac:**
```bash
brew install gh
gh auth login
```

**Windows:**
```bash
winget install --id GitHub.cli
gh auth login
```

**Linux:**
```bash
sudo apt install gh  # Debian/Ubuntu
sudo dnf install gh  # Fedora/RHEL
gh auth login
```

---

## 🎓 Pro Tips

### Tip 1: Validate Before Publishing

Always validate first to see warnings:

```bash
# See warnings before they're buried in publish output
bash harness validate _drafts/post.md

# Then publish
bash harness publish _drafts/post.md --push
```

### Tip 2: Use Aliases

Add to `~/.bashrc` or `~/.zshrc`:

```bash
alias h="bash $PWD/.harness/harness.sh"
```

Then:
```bash
h create "Post" --branch
h publish _drafts/post.md --push
h pr
```

### Tip 3: Check Current Branch

Before creating a PR:

```bash
git branch --show-current
# Should show: post/your-post-name

# Not master or main!
```

### Tip 4: Review Commit Before Pushing

Use `--commit` (without `--push`) to review:

```bash
bash harness publish _drafts/post.md --commit

# Review the commit
git log -1 -p

# If good, push
bash harness push
```

---

## 📊 Workflow Comparison

### Old Way (Manual)
```bash
touch _posts/2026-04-16-my-post.md
# Edit file...
git checkout -b post/my-post
git add _posts/2026-04-16-my-post.md
git commit -m "Add new post"
git push -u origin post/my-post
gh pr create --title "..." --body "..."
```

**Commands:** 7+ manual commands
**Time:** ~5 minutes
**Errors:** Easy to forget steps, typos in commit messages

### New Way (Harness)
```bash
bash harness create "My Post" --branch
# Edit file...
bash harness publish _drafts/2026-04-16-my-post.md --push
bash harness pr
```

**Commands:** 3 harness commands
**Time:** ~30 seconds
**Errors:** Validation catches issues, consistent commit messages

---

## 🎯 Cheat Sheet

```bash
# Create with branch
bash harness create "Title" --branch

# Validate
bash harness validate _drafts/file.md

# Publish + push
bash harness publish _drafts/file.md --push

# Create PR
bash harness pr

# List drafts/posts
bash harness list

# Help
bash harness help
```

---

## 🚀 Next Steps

1. **Try it:** Create a test post
   ```bash
   bash harness create "Test Post" --branch
   ```

2. **Read more:**
   - [Full Git Workflow Guide](GIT-WORKFLOW.md)
   - [Writing Style Guide](rules/style-guide.md)
   - [Architecture](ARCHITECTURE.md)

3. **Customize rules:**
   - Edit [compliance-rules.yml](rules/compliance-rules.yml)
   - Add your own validation patterns

4. **Share feedback:**
   - Found a bug? Fix the harness script
   - Want a feature? Add it!

Happy blogging! 🎉
