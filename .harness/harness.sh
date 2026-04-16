#!/bin/bash

# Content Management Harness CLI
# Manages blog posts with compliance validation

set -e

HARNESS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$HARNESS_DIR")"
POSTS_DIR="$PROJECT_ROOT/_posts"
DRAFTS_DIR="$PROJECT_ROOT/_drafts"
TEMPLATES_DIR="$HARNESS_DIR/templates"
VALIDATOR="$HARNESS_DIR/scripts/validate-content.js"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Ensure drafts directory exists
mkdir -p "$DRAFTS_DIR"

# Helper functions
print_header() {
    echo -e "\n${BOLD}${BLUE}=== $1 ===${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

# Command: create
cmd_create() {
    local title="$1"
    local create_branch=false

    # Check for --branch flag
    if [ "$2" = "--branch" ] || [ "$2" = "-b" ]; then
        create_branch=true
    fi

    if [ -z "$title" ]; then
        print_error "Usage: ./harness.sh create \"Post Title\" [--branch]"
        exit 1
    fi

    # Generate filename
    local date=$(date +%Y-%m-%d)
    local slug=$(echo "$title" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd '[:alnum:]-')
    local filename="${date}-${slug}.md"
    local filepath="$DRAFTS_DIR/$filename"

    # Check if file already exists
    if [ -f "$filepath" ]; then
        print_error "Draft already exists: $filename"
        exit 1
    fi

    # Check for uncommitted changes if creating branch
    if [ "$create_branch" = true ]; then
        if [ -n "$(git status --porcelain)" ]; then
            print_warning "You have uncommitted changes. Commit or stash them first."
            echo ""
            git status --short
            echo ""
            read -p "Continue anyway? (y/n) " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                exit 1
            fi
        fi

        # Get current branch
        local current_branch=$(git branch --show-current)
        print_info "Current branch: $current_branch"

        # Create feature branch
        local branch_name="post/${slug}"
        print_info "Creating branch: $branch_name"

        if git show-ref --verify --quiet refs/heads/"$branch_name"; then
            print_warning "Branch $branch_name already exists. Switching to it."
            git checkout "$branch_name"
        else
            git checkout -b "$branch_name"
            print_success "Created and switched to branch: $branch_name"
        fi
    fi

    # Create from template
    sed -e "s/{{ CURRENT_DATE }}/$date/g" \
        -e "s/{{ TITLE }}/$title/g" \
        "$TEMPLATES_DIR/post-template.md" > "$filepath"

    print_success "Created draft: $filename"
    print_info "Location: $filepath"

    if [ "$create_branch" = true ]; then
        echo ""
        print_info "Git branch created: post/${slug}"
    fi

    echo ""
    print_info "Next steps:"
    echo "  1. Edit the file: code $filepath"
    echo "  2. Validate: ./harness.sh validate $filepath"
    echo "  3. Publish: ./harness.sh publish $filepath --commit"
    if [ "$create_branch" = true ]; then
        echo "  4. Create PR: ./harness.sh pr"
    fi
}

# Command: validate
cmd_validate() {
    local filepath="$1"

    if [ -z "$filepath" ]; then
        print_error "Usage: ./harness.sh validate <markdown-file>"
        exit 1
    fi

    if [ ! -f "$filepath" ]; then
        print_error "File not found: $filepath"
        exit 1
    fi

    # Check if Node.js is installed
    if ! command -v node &> /dev/null; then
        print_error "Node.js is required but not installed"
        print_info "Install Node.js from: https://nodejs.org/"
        exit 1
    fi

    # Run validator
    node "$VALIDATOR" "$filepath"
    exit $?
}

# Command: publish
cmd_publish() {
    local filepath="$1"
    local should_commit=false
    local should_push=false

    # Check for flags
    shift
    while [ $# -gt 0 ]; do
        case "$1" in
            --commit|-c)
                should_commit=true
                ;;
            --push|-p)
                should_commit=true
                should_push=true
                ;;
            *)
                print_error "Unknown flag: $1"
                exit 1
                ;;
        esac
        shift
    done

    if [ -z "$filepath" ]; then
        print_error "Usage: ./harness.sh publish <draft-file> [--commit] [--push]"
        exit 1
    fi

    if [ ! -f "$filepath" ]; then
        print_error "File not found: $filepath"
        exit 1
    fi

    # Validate first
    print_header "Validating before publish"
    if ! node "$VALIDATOR" "$filepath"; then
        print_error "Validation failed. Fix errors before publishing."
        exit 1
    fi

    # Move to _posts
    local filename=$(basename "$filepath")
    local dest="$POSTS_DIR/$filename"

    if [ -f "$dest" ]; then
        print_warning "Post already exists in _posts/. Overwrite? (y/n)"
        read -r response
        if [ "$response" != "y" ]; then
            print_info "Cancelled."
            exit 0
        fi
    fi

    mv "$filepath" "$dest"
    print_success "Published: $filename"
    print_info "Location: $dest"

    # Commit if requested
    if [ "$should_commit" = true ]; then
        print_header "Committing to Git"

        # Extract title from frontmatter for commit message
        local title=$(grep -m 1 "^title:" "$dest" | sed 's/title: *//g' | tr -d '"')

        git add "$dest"
        git add "$DRAFTS_DIR" 2>/dev/null || true  # Add drafts dir to capture deletion

        local commit_msg="Add new post: ${title}"
        git commit -m "$commit_msg"

        print_success "Committed: $commit_msg"

        # Push if requested
        if [ "$should_push" = true ]; then
            print_header "Pushing to remote"
            local current_branch=$(git branch --show-current)

            # Check if branch has upstream
            if git rev-parse --abbrev-ref --symbolic-full-name @{u} > /dev/null 2>&1; then
                git push
            else
                git push -u origin "$current_branch"
            fi

            print_success "Pushed to origin/$current_branch"
        fi
    else
        echo ""
        print_info "Next: Commit and push to deploy"
        echo "  ./harness.sh commit"
        echo "  or"
        echo "  ./harness.sh publish $filepath --commit --push"
    fi
}

# Command: commit
cmd_commit() {
    # Find published posts that aren't committed
    local uncommitted=$(git status --porcelain _posts/ 2>/dev/null)

    if [ -z "$uncommitted" ]; then
        print_info "No uncommitted posts found"
        exit 0
    fi

    print_header "Uncommitted Posts"
    echo "$uncommitted"
    echo ""

    print_warning "Commit these changes? (y/n)"
    read -r response
    if [ "$response" != "y" ]; then
        print_info "Cancelled."
        exit 0
    fi

    # Extract title from the most recent post
    local latest_post=$(ls -t _posts/*.md 2>/dev/null | head -1)
    if [ -n "$latest_post" ]; then
        local title=$(grep -m 1 "^title:" "$latest_post" | sed 's/title: *//g' | tr -d '"')
        local commit_msg="Add new post: ${title}"
    else
        local commit_msg="Update blog posts"
    fi

    git add _posts/
    git commit -m "$commit_msg"

    print_success "Committed: $commit_msg"
    print_info "Next: Push with 'git push' or './harness.sh push'"
}

# Command: push
cmd_push() {
    local current_branch=$(git branch --show-current)

    print_header "Pushing to remote"
    print_info "Branch: $current_branch"

    # Check if branch has upstream
    if git rev-parse --abbrev-ref --symbolic-full-name @{u} > /dev/null 2>&1; then
        git push
    else
        print_info "Setting upstream to origin/$current_branch"
        git push -u origin "$current_branch"
    fi

    print_success "Pushed to origin/$current_branch"
    print_info "Create a PR with: ./harness.sh pr"
}

# Command: pr
cmd_pr() {
    # Check if gh CLI is installed
    if ! command -v gh &> /dev/null; then
        print_error "GitHub CLI (gh) is not installed"
        print_info "Install from: https://cli.github.com/"
        exit 1
    fi

    local current_branch=$(git branch --show-current)
    local default_branch=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')

    # Fallback to common default branch names
    if [ -z "$default_branch" ]; then
        if git show-ref --verify --quiet refs/remotes/origin/master; then
            default_branch="master"
        elif git show-ref --verify --quiet refs/remotes/origin/main; then
            default_branch="main"
        else
            default_branch="master"  # Ultimate fallback
        fi
    fi

    # Check if we're on a feature branch
    if [ "$current_branch" = "$default_branch" ]; then
        print_error "Cannot create PR from $default_branch branch"
        print_info "Create a feature branch first with: ./harness.sh create \"Post Title\" --branch"
        exit 1
    fi

    # Check if there are committed changes
    if ! git log origin/"$default_branch"..HEAD --oneline 2>/dev/null | grep -q .; then
        print_error "No commits to create PR from"
        print_info "Publish and commit your post first"
        exit 1
    fi

    print_header "Creating Pull Request"

    # Get post title from the most recent post commit
    local commit_msg=$(git log -1 --pretty=%B)
    local pr_title=$(echo "$commit_msg" | head -1)

    # Generate PR body
    local pr_body="## New Blog Post

This PR adds a new blog post.

### Validation
✅ Content validated with harness
✅ No security issues detected
✅ Writing style reviewed

### Checklist
- [x] Post validated with \`./harness.sh validate\`
- [x] No sensitive information included
- [x] Writing style is personal and authentic
- [x] UiPath mentions are minimal and relevant

---
🤖 Created with Blog Harness"

    # Create PR
    gh pr create --title "$pr_title" --body "$pr_body" --base "$default_branch"

    if [ $? -eq 0 ]; then
        print_success "Pull Request created!"
        print_info "View your PR: gh pr view --web"
    else
        print_error "Failed to create PR"
        exit 1
    fi
}

# Command: list
cmd_list() {
    print_header "Drafts"
    if [ -n "$(ls -A $DRAFTS_DIR 2>/dev/null)" ]; then
        ls -1 "$DRAFTS_DIR"
    else
        print_info "No drafts found"
    fi

    print_header "Published Posts"
    ls -1t "$POSTS_DIR" | head -10
}

# Command: help
cmd_help() {
    cat << EOF
${BOLD}Content Management Harness${NC}

${BOLD}USAGE:${NC}
    ./harness.sh <command> [arguments]

${BOLD}COMMANDS:${NC}
    ${GREEN}create${NC} "Post Title" [--branch]
        Create a new draft from template
        --branch: Create a Git feature branch for this post

    ${GREEN}validate${NC} <file>
        Validate post for compliance and style

    ${GREEN}publish${NC} <draft-file> [--commit] [--push]
        Validate and move draft to _posts/
        --commit: Auto-commit the published post
        --push: Auto-commit and push to remote

    ${GREEN}commit${NC}
        Commit all published posts

    ${GREEN}push${NC}
        Push current branch to remote

    ${GREEN}pr${NC}
        Create a GitHub Pull Request (requires gh CLI)

    ${GREEN}list${NC}
        List drafts and recent posts

    ${GREEN}help${NC}
        Show this help message

${BOLD}WORKFLOW (Basic):${NC}
    1. Create draft:    ./harness.sh create "My Post Title"
    2. Edit content:    code _drafts/2026-04-16-my-post-title.md
    3. Validate:        ./harness.sh validate _drafts/2026-04-16-my-post-title.md
    4. Publish:         ./harness.sh publish _drafts/2026-04-16-my-post-title.md
    5. Commit:          ./harness.sh commit
    6. Push:            ./harness.sh push

${BOLD}WORKFLOW (Git-Integrated):${NC}
    1. Create with branch:  ./harness.sh create "My Post Title" --branch
    2. Edit content:        code _drafts/2026-04-16-my-post-title.md
    3. Validate:            ./harness.sh validate _drafts/2026-04-16-my-post-title.md
    4. Publish & push:      ./harness.sh publish _drafts/2026-04-16-my-post-title.md --push
    5. Create PR:           ./harness.sh pr

${BOLD}WORKFLOW (One-Command):${NC}
    # Quick publish from existing draft
    ./harness.sh publish _drafts/my-post.md --push

${BOLD}VALIDATION:${NC}
    The validator checks for:
    - ❌ Security issues (blocks publication)
    - ⚠️  LLM-style writing (warnings)
    - ⚠️  Excessive UiPath mentions (warnings)
    - ℹ️  Style recommendations (info)

${BOLD}GIT INTEGRATION:${NC}
    - Create feature branches automatically
    - Auto-commit with descriptive messages
    - Push to remote with upstream tracking
    - Create GitHub PRs with pre-filled templates

${BOLD}STYLE GUIDE:${NC}
    See .harness/rules/style-guide.md for detailed examples

${BOLD}RULES:${NC}
    Edit validation rules in .harness/rules/compliance-rules.yml

EOF
}

# Main command router
main() {
    if [ $# -eq 0 ]; then
        cmd_help
        exit 0
    fi

    local command="$1"
    shift

    case "$command" in
        create)
            cmd_create "$@"
            ;;
        validate)
            cmd_validate "$@"
            ;;
        publish)
            cmd_publish "$@"
            ;;
        commit)
            cmd_commit
            ;;
        push)
            cmd_push
            ;;
        pr)
            cmd_pr
            ;;
        list|ls)
            cmd_list
            ;;
        help|--help|-h)
            cmd_help
            ;;
        *)
            print_error "Unknown command: $command"
            echo "Run './harness.sh help' for usage"
            exit 1
            ;;
    esac
}

main "$@"
