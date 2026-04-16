# Git-Integrated Workflow

The harness now integrates seamlessly with your Git workflow, automating branch creation, commits, pushes, and PR creation.

## 🚀 Quick Start

### Option 1: Fully Automated (Recommended)

```bash
# 1. Create post with auto-branch creation
bash harness create "My New Post" --branch

# 2. Edit the draft
code _drafts/2026-04-16-my-new-post.md

# 3. Validate
bash harness validate _drafts/2026-04-16-my-new-post.md

# 4. Publish, commit, and push in one command
bash harness publish _drafts/2026-04-16-my-new-post.md --push

# 5. Create GitHub PR
bash harness pr
```

### Option 2: Manual Control

```bash
# 1. Create post (no branch)
bash harness create "My New Post"

# 2. Edit
code _drafts/2026-04-16-my-new-post.md

# 3. Validate
bash harness validate _drafts/2026-04-16-my-new-post.md

# 4. Publish (just moves to _posts/)
bash harness publish _drafts/2026-04-16-my-new-post.md

# 5. Commit manually
bash harness commit

# 6. Push manually
bash harness push
```

---

## 📋 Commands Reference

### `create --branch`

Creates a new draft AND a Git feature branch.

```bash
bash harness create "Building a Chat App" --branch
```

**What it does:**
1. Checks for uncommitted changes (warns if found)
2. Creates branch named `post/building-a-chat-app`
3. Switches to the new branch
4. Creates the draft markdown file

**Branch naming:**
- Pattern: `post/{slug}`
- Example: `post/building-a-chat-app`
- Lowercase, hyphenated

### `publish --commit`

Validates, publishes, AND commits the post.

```bash
bash harness publish _drafts/my-post.md --commit
```

**What it does:**
1. Runs validation (blocks if errors found)
2. Moves draft to `_posts/`
3. Creates Git commit with message: "Add new post: {Title}"

### `publish --push`

Validates, publishes, commits, AND pushes to remote.

```bash
bash harness publish _drafts/my-post.md --push
```

**What it does:**
1. Runs validation
2. Moves draft to `_posts/`
3. Creates Git commit
4. Pushes to `origin` (sets upstream if needed)

**Note:** `--push` implies `--commit`

### `commit`

Commits all unpublished posts in `_posts/`.

```bash
bash harness commit
```

**What it does:**
1. Shows uncommitted posts
2. Asks for confirmation
3. Commits with title from most recent post

### `push`

Pushes current branch to remote.

```bash
bash harness push
```

**What it does:**
1. Checks for upstream branch
2. Sets upstream if needed (`-u origin branch-name`)
3. Pushes commits

### `pr`

Creates a GitHub Pull Request.

```bash
bash harness pr
```

**Requirements:**
- GitHub CLI (`gh`) must be installed
- Must be on a feature branch (not `master`/`main`)
- Must have commits to push

**What it does:**
1. Detects your default branch (`master` or `main`)
2. Creates PR with auto-generated title and body
3. Includes validation checklist
4. Opens PR in browser (optional: `gh pr view --web`)

**PR Template:**
```markdown
## New Blog Post

This PR adds a new blog post.

### Validation
✅ Content validated with harness
✅ No security issues detected
✅ Writing style reviewed

### Checklist
- [x] Post validated with `./harness.sh validate`
- [x] No sensitive information included
- [x] Writing style is personal and authentic
- [x] UiPath mentions are minimal and relevant
```

---

## 🎯 Workflow Examples

### Example 1: Quick Blog Post

You're on `master`, want to write a quick post:

```bash
# All-in-one command
bash harness create "Quick Tip" --branch
# Edit the file...
bash harness publish _drafts/2026-04-16-quick-tip.md --push
bash harness pr
```

**Result:** Post is validated, published, committed, pushed, and PR created in ~30 seconds.

### Example 2: Careful Review

You want to review before pushing:

```bash
bash harness create "Important Post" --branch
# Edit...
bash harness validate _drafts/2026-04-16-important-post.md
# Review validation output...
bash harness publish _drafts/2026-04-16-important-post.md --commit
# Review the commit...
git log -1 -p
# If good, push
bash harness push
bash harness pr
```

### Example 3: Multiple Posts

You're publishing several posts:

```bash
bash harness create "Post 1" --branch
# Edit post 1...
bash harness publish _drafts/2026-04-16-post-1.md --push
bash harness pr

# Switch back to master
git checkout master

bash harness create "Post 2" --branch
# Edit post 2...
bash harness publish _drafts/2026-04-16-post-2.md --push
bash harness pr
```

### Example 4: Fix After Validation Failure

Validation caught an issue:

```bash
bash harness publish _drafts/my-post.md --push
# ❌ FAILED: Found "staging" keyword

# Fix the issue
code _drafts/my-post.md

# Try again
bash harness publish _drafts/my-post.md --push
# ✅ PASSED
```

---

## 🔧 Commit Message Format

The harness generates descriptive commit messages automatically:

**Format:**
```
Add new post: {Title from frontmatter}
```

**Examples:**
- `Add new post: Building a ChatGPT-Style App`
- `Add new post: How I Fixed the WebSocket Bug`
- `Add new post: UiPath SDK Quick Start`

---

## 🌳 Branch Naming Convention

**Pattern:** `post/{slug}`

The slug is generated from the post title:
- Lowercase
- Spaces → hyphens
- Special characters removed

**Examples:**

| Post Title | Branch Name |
|------------|-------------|
| "Building a Chat App" | `post/building-a-chat-app` |
| "React + TypeScript Tips" | `post/react-typescript-tips` |
| "How I Fixed Bug #123" | `post/how-i-fixed-bug-123` |

---

## 🛡️ Safety Features

### Uncommitted Changes Check

When creating a branch, harness checks for uncommitted changes:

```bash
bash harness create "New Post" --branch

⚠ You have uncommitted changes. Commit or stash them first.

 M _posts/old-post.md
 
Continue anyway? (y/n)
```

### Validation Before Commit

You can't commit a post that fails validation:

```bash
bash harness publish _drafts/bad-post.md --commit

❌ FAILED: 2 error(s) must be fixed
# Commit blocked!
```

### Branch Protection

Can't create PR from master/main:

```bash
git checkout master
bash harness pr

✗ Cannot create PR from master branch
ℹ Create a feature branch first with: ./harness.sh create "Post Title" --branch
```

---

## 📦 Installing GitHub CLI

The `pr` command requires GitHub CLI:

**Mac:**
```bash
brew install gh
```

**Windows:**
```bash
winget install --id GitHub.cli
```

**Linux:**
```bash
# Debian/Ubuntu
sudo apt install gh

# Fedora/RHEL
sudo dnf install gh
```

**Authenticate:**
```bash
gh auth login
```

---

## 🎓 Best Practices

### 1. Always Create Branch First

```bash
# ✅ Good
bash harness create "Post" --branch

# ❌ Avoid
bash harness create "Post"
# ... later trying to create branch manually
```

### 2. Validate Before Publishing

```bash
# ✅ Good
bash harness validate _drafts/post.md
bash harness publish _drafts/post.md --push

# ❌ Skip validation (risky)
bash harness publish _drafts/post.md --push
# Validation still runs, but you don't see warnings first
```

### 3. Use --push for Speed

```bash
# ✅ Fast workflow
bash harness publish _drafts/post.md --push
bash harness pr

# ❌ Slower (but more control)
bash harness publish _drafts/post.md
bash harness commit
bash harness push
bash harness pr
```

### 4. Review Validation Output

Even if validation passes, check warnings:

```bash
bash harness validate _drafts/post.md

⚠️  WARNINGS:
  • WRITING STYLE: LLM-like phrases detected
  
# Fix the warnings before publishing!
```

---

## 🚨 Troubleshooting

### "No commits to create PR from"

You forgot to publish and commit:

```bash
bash harness publish _drafts/post.md --push
bash harness pr
```

### "Branch already exists"

The harness will switch to the existing branch:

```bash
bash harness create "My Post" --branch

⚠ Branch post/my-post already exists. Switching to it.
```

### "GitHub CLI (gh) is not installed"

Install the GitHub CLI:

```bash
# See "Installing GitHub CLI" section above
brew install gh  # Mac
gh auth login
```

### Accidentally pushed to master

If you forgot to create a branch:

```bash
# Create a new branch from your commit
git checkout -b post/my-post

# Reset master back
git checkout master
git reset --hard origin/master

# Go back to your branch
git checkout post/my-post
```

---

## 📊 Workflow Comparison

| Action | Manual | Harness (Basic) | Harness (Integrated) |
|--------|--------|-----------------|---------------------|
| Create post | `touch _posts/...` | `harness create` | `harness create --branch` |
| Validate | Manual check | `harness validate` | `harness validate` |
| Publish | `mv` command | `harness publish` | `harness publish --push` |
| Create branch | `git checkout -b` | Manual | Automatic |
| Commit | `git add && git commit` | `harness commit` | Automatic |
| Push | `git push` | `harness push` | Automatic |
| Create PR | `gh pr create` | Manual | `harness pr` |
| **Total commands** | ~8 commands | ~5 commands | **3 commands** |

---

## 🎯 Summary

The Git-integrated harness workflow reduces your blog publishing process from **8+ manual commands** to just **3 harness commands**:

```bash
bash harness create "Post" --branch
bash harness publish _drafts/post.md --push
bash harness pr
```

All while maintaining:
- ✅ Security validation
- ✅ Writing style checks
- ✅ Proper Git workflow
- ✅ Professional PRs
- ✅ Audit trail

**Happy blogging! 🚀**
