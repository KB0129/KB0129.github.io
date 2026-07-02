---
layout: post
title: "AI-Ready Codebase Design and Token Cost Optimization"
date: 2026-07-02
categories: [AI, Engineering, Cost-Optimization]
tags: [ai-agents, token-optimization, codebase-design, cost-management, cache-strategy]
---

## Introduction to AI Agent-Friendly Codebase Design and `CLAUDE.md` Improvement

The speaker introduces methods for designing an **AI-ready codebase** where AI agents do not get lost, drawing on experience from Silicon Valley and Meta.

The lecture also introduces a skill for analyzing how AI-friendly a codebase is.

Topics covered include the problem of **token efficiency**, cost control, and how to turn cost dashboards and cost gates into team-level assets.

The lecture raises the issue that when AI agent operating instructions, such as `CLAUDE.md`, do not match the actual codebase environment or "terrain," agents may perform work inefficiently.

## What Is an AI-Ready Codebase?

An AI-ready codebase is a codebase designed so that an AI agent can enter a new session and work accurately without losing its way.

Just as a human developer may need about a week to become familiar with a codebase, AI agents must also re-evaluate their surroundings each time they enter a session.

The cause of agent failure is often not poor code quality itself, but the **cost of exploration and understanding**. If the agent cannot find the right location, it wastes time reading unnecessary code and may create duplicate implementations.

## Practical Example and Problem Analysis

For example, during a payment logic modification task, an agent may miss 5 out of 40 related files, modify duplicate payment code, and then break the tests.

In such cases, 80% of token usage may be spent on exploration, while only 20% is used for actual code modification.

Building an AI-ready codebase is about significantly reducing exploration cost and optimizing the ratio between exploration and code modification.

## Two-Step Process for Building an AI-Ready Codebase

### 1. Check Codebase Health

Maintaining a healthy codebase is the prerequisite. This includes:

- Test coverage
- Dead code removal
- Consistent code conventions
- Removal of code smells

If the codebase is unhealthy, creating an accurate exploration map is meaningless.

### 2. Create Cartography

This means creating a customized codebase "map" for AI agents.

The main elements of the map include:

- Entry points
- Dependency graphs
- Domain glossary
- Disposable or safe-to-change areas
- Accurate task paths

Both codebase health and cartography must be in place for an agent to explore and work efficiently.

## How Code Quality Priorities Change in the AI Era

Traditional human-centered code quality focuses on:

- Ease of maintenance
- Readability
- Bug reduction

AI-centered code quality focuses on different practical effects:

- Test coverage acts as a signal system that enables agent self-verification.
- Consistent conventions are essential for agents to generalize and reuse patterns.
- Dead code removal prevents agents from following incorrect exploration routes.
- Removing code smells prevents agents from reproducing low-quality code.
- Test code plays a central role in allowing AI agents to detect and fix errors inside their feedback loops.

## Detailed Concept of AI-Ready Cartography and Skill Lecture

The core of an AI-focused map is to give the agent accurate "instruction coordinates" so it can recognize the correct entry point.

The map is not just documentation. It includes dependency maps, glossaries, verification routines, and path information.

The speaker developed and provides an **AI Readiness Cartography Skill** that automates this work.

The skill scores several categories and presents the results as a report. Categories include:

- Navigation
- Context quality
- Documentation level
- Dependency mapping
- Verification status
- Freshness
- Outcomes

## AI Readiness Evaluation Demo and Skill Usage Practice

The speaker runs the skill on an actual demo project.

The demo shows how rubric-based scoring works and how the evaluation results identify areas for improvement.

Example evaluation results include:

- Low navigation score
- Good context document quality
- Low scores in other categories

The generated map includes documents such as `CLAUDE.md` and architecture documentation, clearly showing the entry paths that agents should reference.

The report also includes a practical ROI action plan. Suggested actions include:

- Splitting and refining `CLAUDE.md`
- Automating PR verification
- Introducing visualization
- Using ADRs, or Architecture Decision Records

## Need for Regular AI-Ready Codebase Checks and Automation

One-time checks have limited effect. Continuous improvement through regular reviews is essential.

The process of diagnosis, reporting, PR creation, and code application should be automated to reduce cost and improve productivity.

The lecture re-emphasizes that building an AI-ready codebase is the foundation for improving AI agent performance.

## Preview of the Upcoming Second Brain Topic

The lecture previews the topic of building a **second brain**, which organizes non-code knowledge such as ADRs, meeting notes, and design documents so that agents can reference them.

Assets are being accumulated through previous topics such as:

- AI-ready codebases
- `CLAUDE.md` management
- Test-driven development, or TDD
- Continuous deployment, or CD
- AI agent plugin management

## Overview of Token Optimization and Cost Management

As AI usage increases, context size and token consumption rise sharply, creating higher billing costs.

Large codebases, second brains, and specification documents can consume hundreds of thousands of tokens.

This section introduces hands-on practice for analyzing and optimizing token usage through dashboards and cost gate policies.

A token is the smallest unit of text processed by a model. It does not correspond one-to-one with words. Instead, text is split using a BPE, or Byte Pair Encoding, vocabulary.

Approximate token characteristics:

- English: about 0.75 words per token
- Korean: about 1.5 to 2 characters per token, roughly twice as costly
- Code: similar to English

Korean can be used, but English is recommended when maximizing cost efficiency is the priority.

## Token Usage and Cost Examples

| Category | Approximate Token Count | Cost |
|---|---:|---:|
| Input tokens | 500,000 tokens | About 5 USD |
| Output tokens | 100,000 tokens | Included |
| Individual monthly usage | Based on 20 days | About 100 USD |
| Team usage | Based on 20 people | About 1,000 USD |
| Annual usage | Team basis, 12 months | About 12,000 USD |

In large organizations, token costs can increase exponentially.

Without cost control, there is a high risk of rapidly escalating expenses.

## Difference Between Individual and Organizational Cost Awareness

Individual users tend to use AI more carefully because they pay the bill directly.

At the company level, however, users often lack cost awareness and may use AI as though usage were unlimited.

This creates a need for leadership-level control policies.

The lecture plans to present response strategies and optimization guidelines for this problem.

## Role and Importance of Prompt Cache

When the same prefix, or fixed prompt section, is repeatedly sent, the server temporarily stores the computation result in a cache to reduce cost.

The prefix is handled as a cache read rather than a normal input token. Cache read cost is much cheaper than cache write cost, roughly one-tenth of the cost.

Repeated text across sessions, such as `CLAUDE.md` and system prompts, should make use of caching.

The cache TTL, or Time To Live, is about 5 minutes. After that, the cache expires and must be written again.

Long continuous work sessions can maximize the benefit of caching. However, reconnecting during work or changing the prefix can cause a sharp increase in cost.

## Cache-Related Precautions

During a session, avoid changing the prefix, including:

- `CLAUDE.md`
- System prompts
- Model selection

Changing these can delete the existing cache and significantly increase token cost.

For example, switching models mid-session from Opus to Sonnet can remove the cache benefit.

When restoring a session, token limits may force re-input, creating a sudden cost increase.

The lecture mentions a real case in which Claude Code asked the user whether cache loss was acceptable and recommended compacting the session.

## Guide to Efficient Prompt Writing

Fixed information, such as `CLAUDE.md` and second-brain content, should be placed in the cacheable area.

Variable information, such as the current time or user message, should be separated into the cache-miss area.

For example, placing the current time later in the prompt can maximize the size of the cacheable area.

Many open-source LLM tools and systems are also developing prompt builders based on this caching concept.

## Six Core Techniques for Token Optimization

1. Read large files once and use cache effectively. Claude Code handles some of this automatically.
2. Place `CLAUDE.md` near the top of the document structure for quick reference.
3. Delegate heavy exploration tasks to separate sub-agents to prevent excessive output token usage during exploration.
4. Use compacting for long sessions, while recognizing that starting a new session is sometimes more efficient.
5. Do not change the prefix or model in the middle of a session.
6. Reuse results from the same engine call to avoid duplicate token consumption.

Optimization becomes more effective when users have a basic understanding of how AI agents work.

## Anti-Patterns and Inefficient Practices to Avoid

Avoid repeatedly sending large files in every session. This can quickly exceed the session token limit.

Avoid duplicate context input, as it neutralizes the benefit of caching.

Avoid keeping a prefix cache that will not be used within 5 minutes, as this can increase unnecessary cost.

Avoid frequent `CLAUDE.md` resets and session resets during work, as they reduce cache effectiveness.

Avoid careless offloading strategies, which can create excessive costs.

Avoid simply retaining completed work nodes, as this wastes context.

It is important to remember that reducing cost too aggressively may also reduce AI performance.

## Practice Using Token Consumption Logs and Analysis Skills

The lecture demonstrates automatically parsing JSON log files from Claude Code sessions to generate token and cost usage dashboard reports.

The logs include:

- Input tokens
- Output tokens
- Cache read information
- Cache write information

The analysis script visualizes session-level and project-level efficiency, cost, cache hit rate, and tool call frequency.

The system uses rubric-based scoring and can be customized for each team or company.

## Key Report Metrics and Evaluation Criteria

| Metric | Description | Top Score Standard |
|---|---|---|
| Cache utilization | Ratio of cache read tokens compared to input tokens | 0.85 or higher |
| Output token density | Ratio of input tokens to output tokens | If too low, it may indicate excessive exploration |
| Tool call frequency | Number of tool calls per 1K output tokens | 2 to 10 is appropriate; 20 or more indicates excessive exploration |
| Total cost | USD-converted cost by session and project | Varies by situation; teams should identify an appropriate level |

The higher the cache utilization, the more unnecessary token retransmission is reduced, resulting in greater cost savings.

## Real-World Example and Dashboard Demonstration

In a test project, there were:

- 31 active sessions
- 347 USD in total cost
- 11 USD average cost per session

The cache hit rate was 89%, and the average number of tool calls was 13, which was relatively good.

The score was around the 90-point range and was acceptable overall, but the score could decline as the amount of work increases.

The dashboard can reveal recommendations such as:

- Too many cache misses
- Insufficient compacting
- Excessive offloading

## Concept and Use of Cost Gates

A dashboard visualizes past cost data, while a cost gate provides real-time cost monitoring and proactive alerts or controls.

A cost gate can implement warnings or execution-stop hooks when token usage exceeds a threshold at the session level.

At the PR level, if cumulative session cost exceeds a threshold, it can trigger labeling and follow-up optimization actions.

The lecture proposes a systematic cost reduction strategy that combines real-time cost management with post-work cost improvement.

## Turning Cost Management into a Team-Level Shared Asset

The key to cost reduction is optimizing caching and token efficiency not at the individual level, but at the team, department, or organizational level.

The lecture emphasizes the importance of building a process that connects automation hooks and dashboards to usage monitoring and improvement execution.

The lecture concludes by previewing the next section, which will cover how to use AI for code reviews.
