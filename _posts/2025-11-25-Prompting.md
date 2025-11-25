# My Deep Dive into Prompt Engineering: Thoughts on Google’s Latest Guide

[cite_start]I recently spent some time with a whitepaper on Prompt Engineering by Lee Boonstra from Google, and I wanted to share my takeaways[cite: 2, 4]. [cite_start]What I loved about this read is that it reinforces the idea that you don't need to be a data scientist to write a prompt—everyone can do it[cite: 28]. [cite_start]However, crafting *effective* prompts is an iterative process that requires understanding how the model actually predicts the next token[cite: 32, 41].

Here is my review of the core concepts and techniques that stood out to me.

## It’s All About the Configuration
[cite_start]One of the first things that struck me was that prompting isn't just about the words you type; it's about the "knobs" you turn on the model configuration[cite: 55].

* [cite_start]**The "Creativity" Knobs:** I learned that **Temperature** controls the randomness[cite: 75]. [cite_start]Lower temperatures are great for deterministic, factual answers, while higher temperatures yield diverse, unexpected results[cite: 75].
* **Sampling Controls:** The paper dives into **Top-K** and **Top-P**. [cite_start]Top-K limits the model to the top *K* most likely tokens [cite: 90][cite_start], while Top-P selects tokens based on cumulative probability[cite: 95].
* [cite_start]**The "Goldilocks" Setting:** The author suggests a solid starting point for coherent but creative results: Temperature 0.2, Top-P 0.95, and Top-K 30[cite: 111]. [cite_start]If you want just facts (like math), set Temperature to 0[cite: 112].

## Moving Beyond Basic Prompts
The paper does a great job explaining the progression from simple to complex prompting.

### 1. The "Shot" Methodology
[cite_start]We start with **Zero-shot**, which is basically just asking the model to do something without examples (e.g., "Classify this movie review")[cite: 123, 128]. [cite_start]But when that fails, **Few-shot** prompting is the way to go[cite: 143]. [cite_start]By providing 3 to 5 examples, we can force the model to follow a specific pattern[cite: 147].

### 2. Role & Context
I found the distinction between **System**, **Contextual**, and **Role** prompting really helpful.
* [cite_start]**System prompts** define the "big picture" or the model's capability[cite: 158].
* [cite_start]**Role prompting** gives the model a persona (like a "travel guide" or "cynical editor") to influence style and tone[cite: 161, 188].
* [cite_start]**Contextual prompts** provide the immediate background info needed for the specific task[cite: 160].

## The Advanced Stuff: Making the AI "Think"
This was the most fascinating part of the document. We can actually trick LLMs into reasoning better.

* [cite_start]**Step-Back Prompting:** This technique asks the model to answer a general question about a topic *before* diving into the specific task[cite: 225]. It grounds the model in background knowledge first.
* [cite_start]**Chain of Thought (CoT):** LLMs struggle with math and logic[cite: 275]. [cite_start]CoT forces the model to generate intermediate reasoning steps (literally asking it to "think step by step"), which significantly improves accuracy[cite: 262, 279].
* [cite_start]**Tree of Thoughts (ToT):** This visualizes reasoning as a tree where the model explores multiple paths simultaneously rather than a linear line[cite: 363].
* **ReAct:** This stands for "Reason and Act." [cite_start]It allows the model to reason about a problem and then take actions—like using external tools or search—to solve it[cite: 370, 373].

## Coding and Automation
The guide also covers how Gemini can act as a developer. [cite_start]It can write, explain, translate, and even debug code[cite: 419, 440, 459, 473]. [cite_start]There is even a concept called **Automatic Prompt Engineering (APE)**, where you ask the model to generate its own prompt variants and evaluate them to find the best one[cite: 399].

## My Favorite Best Practices
If you take anything away from this review, let it be these tips from the "Best Practices" section:

1.  **Be Positive:** Use instructions (what *to* do) over constraints (what *not* to do). [cite_start]Humans and AI both prefer positive reinforcement[cite: 520, 521].
2.  [cite_start]**Use JSON:** For extracting data, asking for JSON output helps limit hallucinations and forces structure[cite: 560].
3.  **Document Your Work:** This is crucial. Prompt engineering is scientific. [cite_start]You should track your prompts, settings (temperature, etc.), and results in a spreadsheet to monitor what works[cite: 586, 590].
4.  [cite_start]**JSON Repair:** If your output gets cut off (truncated), libraries like `json-repair` can save the day by fixing the broken syntax[cite: 567].

## Final Thoughts
[cite_start]The biggest takeaway for me is that prompt engineering is an **iterative process**[cite: 599]. You have to tinker, test, and refine. [cite_start]Whether you are using simple zero-shot prompts or complex reasoning chains like ReAct, the goal is always to guide the prediction engine to the right sequence of tokens[cite: 41].
