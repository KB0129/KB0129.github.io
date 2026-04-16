#!/usr/bin/env node

/**
 * Content Validation Script
 * Enforces compliance and style rules for blog posts
 */

const fs = require('fs');
const path = require('path');
const yaml = require('js-yaml');

// ANSI color codes for terminal output
const colors = {
  reset: '\x1b[0m',
  red: '\x1b[31m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
  green: '\x1b[32m',
  bold: '\x1b[1m',
};

class ContentValidator {
  constructor(rulesPath) {
    this.rules = this.loadRules(rulesPath);
    this.errors = [];
    this.warnings = [];
    this.info = [];
  }

  loadRules(rulesPath) {
    try {
      const fileContents = fs.readFileSync(rulesPath, 'utf8');
      return yaml.load(fileContents);
    } catch (e) {
      console.error(`Failed to load rules: ${e.message}`);
      process.exit(1);
    }
  }

  validate(filePath) {
    console.log(`\n${colors.bold}Validating: ${filePath}${colors.reset}\n`);

    const content = fs.readFileSync(filePath, 'utf8');
    const { frontmatter, body } = this.parseFrontmatter(content);

    // Run all validation checks
    this.checkSecurity(body, filePath);
    this.checkWritingStyle(body);
    this.checkFrontmatter(frontmatter);
    this.checkUiPathMentions(body);

    // Print results
    this.printResults();

    // Return exit code
    return this.errors.length === 0 ? 0 : 1;
  }

  parseFrontmatter(content) {
    // Normalize line endings to handle Windows \r\n
    const normalized = content.replace(/\r\n/g, '\n');
    const match = normalized.match(/^---\n([\s\S]*?)\n---\n([\s\S]*)$/);
    if (!match) {
      this.errors.push('Missing frontmatter');
      return { frontmatter: {}, body: content };
    }

    try {
      const frontmatter = yaml.load(match[1]);
      const body = match[2];
      return { frontmatter, body };
    } catch (e) {
      this.errors.push(`Invalid frontmatter YAML: ${e.message}`);
      return { frontmatter: {}, body: content };
    }
  }

  checkSecurity(content, filePath) {
    const { security } = this.rules;

    // Check sensitive keywords
    security.sensitive_keywords.forEach(keyword => {
      const regex = new RegExp(`\\b${keyword}\\b`, 'gi');
      const matches = content.match(regex);
      if (matches) {
        this.errors.push(
          `SECURITY: Found sensitive keyword "${keyword}" (${matches.length} occurrences)`
        );
      }
    });

    // Check blocked URLs
    security.blocked_url_patterns.forEach(pattern => {
      const regexPattern = pattern.replace(/\*/g, '[^\\s]*');
      const regex = new RegExp(regexPattern, 'gi');
      const matches = content.match(regex);
      if (matches) {
        this.errors.push(
          `SECURITY: Found blocked URL pattern "${pattern}": ${matches.join(', ')}`
        );
      }
    });

    // Check for credentials
    security.credential_patterns.forEach(pattern => {
      const regex = new RegExp(pattern, 'gi');
      const matches = content.match(regex);
      if (matches) {
        this.errors.push(
          `SECURITY: Possible credential/secret detected: "${pattern}"`
        );
      }
    });

    // Check internal patterns
    security.internal_patterns.forEach(pattern => {
      if (content.includes(pattern)) {
        this.errors.push(
          `SECURITY: Internal code/config pattern detected: "${pattern}"`
        );
      }
    });
  }

  checkWritingStyle(content) {
    const { writing_style } = this.rules;

    // Check for LLM indicators
    const llmPatterns = writing_style.llm_indicators.patterns;
    const foundLlmPatterns = [];

    llmPatterns.forEach(pattern => {
      const regex = new RegExp(pattern, 'gi');
      const matches = content.match(regex);
      if (matches) {
        foundLlmPatterns.push(`"${pattern}" (${matches.length}x)`);
      }
    });

    if (foundLlmPatterns.length > 0) {
      this.warnings.push(
        `WRITING STYLE: LLM-like phrases detected:\n  ${foundLlmPatterns.join('\n  ')}\n  💡 Tip: Rewrite in your personal voice`
      );
    }

    // Check for promotional language
    const promoPatterns = writing_style.promotional_indicators.patterns;
    const foundPromoPatterns = [];

    promoPatterns.forEach(pattern => {
      const regex = new RegExp(pattern, 'gi');
      const matches = content.match(regex);
      if (matches) {
        foundPromoPatterns.push(`"${matches[0]}"`);
      }
    });

    if (foundPromoPatterns.length > 0) {
      this.warnings.push(
        `WRITING STYLE: Promotional language detected:\n  ${foundPromoPatterns.join('\n  ')}\n  💡 Tip: Focus on technical content, not marketing`
      );
    }

    // Check voice guidelines
    const encouraged = writing_style.voice_guidelines.encouraged;
    const discouraged = writing_style.voice_guidelines.discouraged;

    const foundEncouraged = encouraged.some(phrase =>
      content.toLowerCase().includes(phrase.toLowerCase())
    );

    const foundDiscouraged = [];
    discouraged.forEach(phrase => {
      const regex = new RegExp(phrase, 'gi');
      const matches = content.match(regex);
      if (matches) {
        foundDiscouraged.push(`"${phrase}"`);
      }
    });

    if (foundDiscouraged.length > 0) {
      this.warnings.push(
        `WRITING STYLE: Impersonal voice detected:\n  ${foundDiscouraged.join(', ')}\n  💡 Tip: Use first-person perspective (I/my)`
      );
    }

    if (foundEncouraged) {
      this.info.push('✓ Good use of personal voice');
    }
  }

  checkFrontmatter(frontmatter) {
    const { content_structure } = this.rules;

    // Check required fields
    content_structure.required_frontmatter.forEach(field => {
      if (!frontmatter[field]) {
        this.errors.push(`FRONTMATTER: Missing required field "${field}"`);
      }
    });

    // Check recommended fields
    content_structure.recommended_frontmatter.forEach(field => {
      if (!frontmatter[field]) {
        this.info.push(`Consider adding "${field}" to frontmatter`);
      }
    });

    // Validate excerpt
    if (frontmatter.excerpt) {
      const excerptLength = frontmatter.excerpt.length;
      const { min_length, max_length } = content_structure.excerpt;

      if (excerptLength < min_length) {
        this.warnings.push(
          `EXCERPT: Too short (${excerptLength} chars). Recommended: ${min_length}-${max_length}`
        );
      } else if (excerptLength > max_length) {
        this.warnings.push(
          `EXCERPT: Too long (${excerptLength} chars). Recommended: ${min_length}-${max_length}`
        );
      }
    }

    // Check categories
    if (frontmatter.categories) {
      const categories = Array.isArray(frontmatter.categories)
        ? frontmatter.categories
        : [frontmatter.categories];

      const allowedCategories = content_structure.allowed_categories;
      const invalidCategories = categories.filter(
        cat => !allowedCategories.includes(cat)
      );

      if (invalidCategories.length > 0) {
        this.warnings.push(
          `CATEGORIES: Unknown categories: ${invalidCategories.join(', ')}\n  Allowed: ${allowedCategories.join(', ')}`
        );
      }
    }
  }

  checkUiPathMentions(content) {
    const maxMentions = this.rules.writing_style.promotional_indicators.max_uipath_mentions;
    const uipathRegex = /\bUiPath\b/g;
    const matches = content.match(uipathRegex);
    const count = matches ? matches.length : 0;

    if (count > maxMentions) {
      this.warnings.push(
        `UIPATH MENTIONS: Found ${count} mentions (max recommended: ${maxMentions})\n  💡 Tip: Only mention UiPath when genuinely relevant`
      );
    } else if (count > 0) {
      this.info.push(`✓ UiPath mentions: ${count} (within guidelines)`);
    }
  }

  printResults() {
    // Print errors
    if (this.errors.length > 0) {
      console.log(`${colors.red}${colors.bold}❌ ERRORS (blocking):${colors.reset}`);
      this.errors.forEach(error => {
        console.log(`${colors.red}  • ${error}${colors.reset}`);
      });
      console.log();
    }

    // Print warnings
    if (this.warnings.length > 0) {
      console.log(`${colors.yellow}${colors.bold}⚠️  WARNINGS:${colors.reset}`);
      this.warnings.forEach(warning => {
        console.log(`${colors.yellow}  • ${warning}${colors.reset}`);
      });
      console.log();
    }

    // Print info
    if (this.info.length > 0) {
      console.log(`${colors.blue}${colors.bold}ℹ️  INFO:${colors.reset}`);
      this.info.forEach(info => {
        console.log(`${colors.blue}  • ${info}${colors.reset}`);
      });
      console.log();
    }

    // Print summary
    if (this.errors.length === 0 && this.warnings.length === 0) {
      console.log(`${colors.green}${colors.bold}✅ PASSED: No issues found!${colors.reset}\n`);
    } else if (this.errors.length === 0) {
      console.log(`${colors.green}${colors.bold}✅ PASSED: No blocking errors${colors.reset}`);
      console.log(`${colors.yellow}   ${this.warnings.length} warning(s) - review recommended${colors.reset}\n`);
    } else {
      console.log(`${colors.red}${colors.bold}❌ FAILED: ${this.errors.length} error(s) must be fixed${colors.reset}\n`);
    }

    // Print custom guidelines
    console.log(`${colors.bold}📖 Remember:${colors.reset}`);
    console.log(`   ${this.rules.custom.personal_style.message}`);
    console.log(`   See .harness/rules/style-guide.md for examples\n`);
  }
}

// CLI entry point
if (require.main === module) {
  const args = process.argv.slice(2);

  if (args.length === 0) {
    console.log('Usage: node validate-content.js <markdown-file>');
    process.exit(1);
  }

  const filePath = args[0];

  if (!fs.existsSync(filePath)) {
    console.error(`File not found: ${filePath}`);
    process.exit(1);
  }

  const rulesPath = path.join(__dirname, '..', 'rules', 'compliance-rules.yml');
  const validator = new ContentValidator(rulesPath);
  const exitCode = validator.validate(filePath);

  process.exit(exitCode);
}

module.exports = ContentValidator;
