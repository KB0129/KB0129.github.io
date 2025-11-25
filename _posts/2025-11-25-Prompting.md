---
layout: default
title: "My Deep Dive into Prompt Engineering: Thoughts on Google’s Latest"
date: 2025-11-25
categories:
  - Knowledge Base
tags:
  - AI Engineering
  - Prompt Engineering
---

# My Deep Dive into Prompt Engineering: Thoughts on Google’s Latest Guide

I recently spent some time with a whitepaper on Prompt Engineering by Lee Boonstra from Google, and I wanted to share my takeaways. What I loved about this read is that it reinforces the idea that you don't need to be a data scientist to write a prompt—everyone can do it. However, crafting *effective* prompts is an iterative process that requires understanding how the model actually predicts the next token.

Here is my review of the core concepts and techniques that stood out to me.

## It’s All About the Configuration
One of the first things that struck me was that prompting isn't just about the words you type; it's about the "knobs" you turn on the model configuration.

* **The "Creativity" Knobs:** I learned that **Temperature** controls the randomness. Lower temperatures are great for deterministic, factual answers, while higher temperatures yield diverse, unexpected results.
* **Sampling Controls:** The paper dives into **Top-K** and **Top-P**. Top-K limits the model to the top *K* most likely tokens, while Top-P selects tokens based on cumulative probability.
* **The "Goldilocks" Setting:** The author suggests a solid starting point for coherent but creative results: Temperature 0.2, Top-P 0.95, and Top-K 30. If you want just facts (like math), set Temperature to 0.

## Moving Beyond Basic Prompts
The paper does a great job explaining the progression from simple to complex prompting.

### 1. The "Shot" Methodology
We start with **Zero-shot**, which is basically just asking the model to do something without examples (e.g., "Classify this movie review"). But when that fails, **Few-shot** prompting is the way to go. By providing 3 to 5 examples, we can force the model to follow a specific pattern.

### 2. Role & Context
I found the distinction between **System**, **Contextual**, and **Role** prompting really helpful.
* **System prompts** define the "big picture" or the model's capability.
* **Role prompting** gives the model a persona (like a "travel guide" or "cynical editor") to influence style and tone.
* **Contextual prompts** provide the immediate background info needed for the specific task.

## The Advanced Stuff: Making the AI "Think"
This was the most fascinating part of the document. We can actually trick LLMs into reasoning better.

* **Step-Back Prompting:** This technique asks the model to answer a general question about a topic *before* diving into the specific task. It grounds the model in background knowledge first.
* **Chain of Thought (CoT):** LLMs struggle with math and logic. CoT forces the model to generate intermediate reasoning steps (literally asking it to "think step by step"), which significantly improves accuracy.
* **Tree of Thoughts (ToT):** This visualizes reasoning as a tree where the model explores multiple paths simultaneously rather than a linear line.
* **ReAct:** This stands for "Reason and Act." It allows the model to reason about a problem and then take actions—like using external tools or search—to solve it.

## Coding and Automation
The guide also covers how Gemini can act as a developer. It can write, explain, translate, and even debug code. There is even a concept called **Automatic Prompt Engineering (APE)**, where you ask the model to generate its own prompt variants and evaluate them to find the best one.

## My Favorite Best Practices
If you take anything away from this review, let it be these tips from the "Best Practices" section:

1.  **Be Positive:** Use instructions (what *to* do) over constraints (what *not* to do). Humans and AI both prefer positive reinforcement.
2.  **Use JSON:** For extracting data, asking for JSON output helps limit hallucinations and forces structure.
3.  **Document Your Work:** This is crucial. Prompt engineering is scientific. You should track your prompts, settings (temperature, etc.), and results in a spreadsheet to monitor what works.
4.  **JSON Repair:** If your output gets cut off (truncated), libraries like `json-repair` can save the day by fixing the broken syntax.

## Final Thoughts
The biggest takeaway for me is that prompt engineering is an **iterative process**. You have to tinker, test, and refine. Whether you are using simple zero-shot prompts or complex reasoning chains like ReAct, the goal is always to guide the prediction engine to the right sequence of tokens.

## References
- Boonstra, L. (Google). *Prompt Engineering Whitepaper*. [Available on Google Drive](https://drive.google.com/file/d/1AbaBYbEa_EbPelsT40-vj64L-2IwUJHy/view?pli=1)
