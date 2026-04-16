# Writing Style Guide for KB0129's Blog

## Purpose
This guide helps you write in your authentic voice while avoiding LLM-generated or corporate language.

---

## ✅ DO: Write Like Yourself

### Personal Experience
```markdown
✅ "I spent 3 hours debugging this before I realized..."
✅ "Here's what worked for me after trying 5 different approaches"
✅ "I ran into this weird bug when..."

❌ "Developers commonly encounter..."
❌ "Users may experience..."
❌ "It is recommended that..."
```

### Technical Explanations
```markdown
✅ "The SDK expects you to pass a config object like this:"
✅ "I found that setting up authentication was tricky because..."
✅ "First, install the package. Then create a .env file."

❌ "To leverage the power of the SDK, one must..."
❌ "The robust authentication mechanism provides..."
❌ "It's worth noting that the configuration..."
```

### Problem-Solution Format
```markdown
✅ "The Problem: My app kept crashing when..."
✅ "What I Tried: First I thought it was..."
✅ "The Fix: Turns out I needed to..."

❌ "In today's digital landscape, applications may encounter..."
❌ "By implementing a robust solution, we can seamlessly..."
```

---

## ❌ AVOID: LLM/Corporate Language

### Generic LLM Phrases
- ❌ "It's important to note that..."
- ❌ "It's worth noting..."
- ❌ "In today's digital landscape..."
- ❌ "Leverage the power of..."
- ❌ "Harness the potential..."
- ❌ "Seamlessly integrate..."
- ❌ "Robust solution..."
- ❌ "Cutting-edge technology..."

### Overly Formal Transitions
- ❌ "Furthermore..."
- ❌ "Moreover..."
- ❌ "Subsequently..."
- ❌ "Thus, we can conclude..."

Use instead:
- ✅ "Also..."
- ✅ "Next..."
- ✅ "Then..."
- ✅ "So..."

---

## 🎯 UiPath Mention Guidelines

### When to Mention UiPath
✅ When genuinely relevant to the tutorial
✅ When specifying which SDK/API you're using
✅ When sharing your experience as a UiPath engineer

### How to Mention UiPath
```markdown
✅ "I used the UiPath Conversational Agent SDK for this project"
✅ "As a Forward Deployed Engineer at UiPath, I work with..."
✅ "The UiPath TypeScript CLI makes deployment easier"

❌ "UiPath's industry-leading automation platform..."
❌ "UiPath provides a comprehensive, enterprise-grade solution..."
❌ "Powered by UiPath's cutting-edge technology..."
```

### Link Guidelines
- ✅ Link to `docs.uipath.com` when readers need official documentation
- ✅ Link to `academy.uipath.com` for learning resources
- ❌ Avoid excessive linking to UiPath marketing pages
- ❌ Don't link to internal/staging environments

---

## 📝 Post Structure

### Title
```markdown
✅ "Building a Chat App with UiPath SDK"
✅ "How I Fixed the WebSocket Connection Issue"
✅ "Setting Up UiPath Coded Automation - Quick Start"

❌ "Leveraging UiPath's Robust SDK for Enterprise Solutions"
❌ "A Comprehensive Guide to Revolutionary Automation"
```

### Introduction
```markdown
✅ Start with the problem or goal
✅ Share why you built this
✅ Mention if you struggled with something

Example:
"I needed to build a ChatGPT-like interface for a client project. 
After trying a few approaches, I found the UiPath Conversational 
Agent SDK was the best fit. Here's how I set it up."
```

### Body
- Use short paragraphs (3-5 lines max)
- Include code snippets with comments
- Share gotchas and mistakes you made
- Explain WHY you made certain choices

### Conclusion
```markdown
✅ "That's it! This setup has been working well for my projects."
✅ "Hope this helps if you run into the same issue."
✅ "Let me know if you hit any snags."

❌ "In conclusion, we have demonstrated..."
❌ "To sum up, this robust solution provides..."
```

---

## 🔍 Self-Check Before Publishing

Ask yourself:
1. **Does this sound like me talking to a colleague?**
   - If not, rewrite in a more conversational tone

2. **Am I promoting UiPath or sharing knowledge?**
   - Focus on technical content, not marketing

3. **Would I write this by hand, or does it sound AI-generated?**
   - Watch for "it's worth noting", "leverage", "seamless", etc.

4. **Am I sharing my actual experience?**
   - Include real problems you faced
   - Mention time spent debugging
   - Share what didn't work

5. **Could this be published on UiPath's marketing site?**
   - If yes, make it more personal and technical

---

## 📊 Example: Before/After

### ❌ BEFORE (Too LLM/Corporate)
```markdown
In today's rapidly evolving digital landscape, building conversational 
AI applications has become increasingly important. UiPath's robust and 
cutting-edge Conversational Agent SDK provides developers with a 
comprehensive, enterprise-grade solution for seamlessly integrating 
AI-powered conversational experiences into their applications.

It's worth noting that the SDK leverages the power of...
```

### ✅ AFTER (Personal & Technical)
```markdown
I needed to build a ChatGPT-style app for a client project. I looked 
at a few options and ended up using the UiPath Conversational Agent SDK 
because it had WebSocket support and good TypeScript types.

Setup took about 2 hours. Here's what I learned:
```

---

## 🎯 Remember

**Your blog is YOUR technical journal**, not a product marketing page.

Write like you're explaining something to a friend over coffee, not like 
you're writing corporate documentation.

Readers come for authentic insights and real experiences, not polished 
marketing copy.
