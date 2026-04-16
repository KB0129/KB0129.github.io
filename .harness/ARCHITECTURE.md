# Content Management Harness Architecture

## Overview

This harness provides a structured framework for managing blog content with built-in compliance validation, ensuring that no sensitive or internal company information is accidentally published.

## Architecture Layers

### 1. Input Layer
**Purpose**: Provide CLI tools for content management operations

**Components**:
- `harness.sh` - Main CLI entry point
- Post creation templates
- Interactive post wizard

**Operations**:
- Create new post from template
- Edit existing post
- Delete post (with safety checks)
- Validate post compliance
- List all posts

### 2. Validation Layer (Compliance Engine)
**Purpose**: Enforce company policy and prevent sensitive information leaks

**Components**:
- `rules/compliance-rules.yml` - Configurable validation rules
- `scripts/validate-content.js` - Content scanner
- Pattern matchers for sensitive data

**Validation Checks**:
1. **Sensitive Keywords Detection**
   - Internal environment names (staging, dev, internal)
   - Confidential markers
   - Unreleased product names
   
2. **URL/Endpoint Validation**
   - Block internal/staging URLs
   - Allow only public documentation
   - Check for exposed API endpoints
   
3. **Credential Detection**
   - API keys, tokens, passwords
   - Internal IPs and domains
   - Service account names
   
4. **Code/Config Validation**
   - Environment variables
   - Internal configuration
   - Non-public folder structures

5. **Metadata Compliance**
   - Required frontmatter fields
   - Category restrictions
   - Tag validation

### 3. Processing Layer
**Purpose**: Transform and enhance content

**Components**:
- Frontmatter validator
- Markdown linter
- Image optimizer
- SEO metadata generator
- Excerpt generator

**Operations**:
- Validate frontmatter schema
- Format markdown consistently
- Optimize images for web
- Generate SEO-friendly metadata
- Create post excerpts

### 4. Storage Layer
**Purpose**: Organize content by status

**Structure**:
```
_posts/           # Published posts (passed validation)
_drafts/          # Work in progress (may contain issues)
.harness/
  ├── rules/      # Validation rules configuration
  ├── templates/  # Post templates
  ├── logs/       # Audit trail of validations
  └── scripts/    # Automation scripts
```

## Workflow

### Creating a New Post

```bash
# Step 1: Create draft from template
./harness.sh create "My New Post"

# Step 2: Write content in _drafts/

# Step 3: Validate compliance
./harness.sh validate _drafts/my-new-post.md

# Step 4: If validation passes, publish
./harness.sh publish _drafts/my-new-post.md

# Step 5: Commit and push (Jekyll builds automatically)
```

### Validation Flow

```
┌─────────────────┐
│  Author writes  │
│   markdown      │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Run harness     │
│  validation     │
└────────┬────────┘
         │
         ▼
    ┌────┴────┐
    │ Valid?  │
    └────┬────┘
         │
    ┌────┴────┐
    │         │
   YES       NO
    │         │
    ▼         ▼
┌───────┐  ┌──────────────┐
│Publish│  │ Show errors  │
│ post  │  │ Block commit │
└───────┘  └──────────────┘
```

## Security Benefits

1. **Prevent Information Leaks**
   - Automated scanning before publication
   - Audit trail of all validations
   - Clear feedback on violations

2. **Company Policy Enforcement**
   - Configurable rules for your organization
   - Consistent compliance across all posts
   - Reduce manager review burden

3. **Developer Safety**
   - Pre-commit hooks prevent accidents
   - CI/CD validation as backup
   - Clear guidelines in templates

## Configuration

All validation rules are configurable in `.harness/rules/compliance-rules.yml`:

```yaml
# Example structure
sensitive_keywords:
  - internal
  - staging
  - confidential
  
blocked_domains:
  - "*.internal.uipath.com"
  - "staging.uipath.com"
  
allowed_domains:
  - "docs.uipath.com"
  - "cloud.uipath.com"
```

## Extensibility

The harness is designed to be extended:
- Add new validation rules in YAML
- Create custom validators in JavaScript
- Add new templates for different post types
- Integrate with external APIs (Grammarly, etc.)

## Future Enhancements

1. **AI-Powered Analysis**
   - Use LLM to detect subtle compliance issues
   - Suggest safer alternatives for flagged content
   
2. **Integration with Company Systems**
   - Query internal compliance database
   - Sync with approved terminology list
   
3. **Rich CLI Interface**
   - Interactive validation feedback
   - Preview mode with warnings highlighted
   
4. **Automated Remediation**
   - Suggest fixes for common issues
   - Auto-redact sensitive patterns

## Maintenance

- Review validation logs regularly
- Update rules when company policy changes
- Add new patterns as issues are discovered
- Test harness with known sensitive content
