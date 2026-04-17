---
layout: default
title: "Testing a UiPath Coded Agent with a Hugging Face Model"
date: 2026-04-17
categories: [UiPath, Python, AI]
excerpt: "I built a small UiPath coded agent that calls a Hugging Face chat model and reports where the token came from. Here's the pattern I'd reuse for other external model clients."
tags: [uipath, coded-agent, hugging-face, python]
author: "Kyungbin Lee"
---

# Testing a UiPath Coded Agent with a Hugging Face Model

I wanted a very small project that could answer one question fast: can I call a Hugging Face chat model from a UiPath coded agent without adding a lot of framework code first?

The project I ended up with is `00_CodedAgent_HuggingFaceTest`. It is basically a one-node harness. The agent takes a message, sends it to a Hugging Face model, and returns both the model response and a little bit of debug information that helps me see where things worked or failed.

That simplicity is what I liked most. I only needed `uipath` and `huggingface-hub`, and the generated entry point stayed easy to read.

## What the agent exposes

The input contract is tiny:

```python
@dataclass
class HuggingFaceTestInput:
    message: str
    model: str = DEFAULT_MODEL
```

I made `message` required and kept `model` optional so I could swap models without rewriting the function.

The output is also small, but it gives enough information to debug a failed run:

```python
@dataclass
class HuggingFaceTestOutput:
    success: bool
    model: str
    token_source: str
    response_message: str
    error_message: str = ""
```

That `token_source` field ended up being more useful than I expected. When I am testing from different environments, I can tell right away whether the run picked up the Orchestrator asset or the fallback environment variable.

## The part I cared about most

The most practical part of this project is the token-loading order. I wanted the agent to prefer a managed value from Orchestrator, but I also wanted a fallback that made local testing easy.

This is the flow I used:

```python
def load_token() -> tuple[str, str]:
    try:
        client = UiPath()
        asset = client.assets.retrieve(name=HUGGINGFACE_ASSET_NAME)
        token = getattr(asset, "value", None) or getattr(asset, "string_value", None)
        if token:
            return str(token).strip(), "orchestrator_asset"
    except Exception:
        pass

    env_token = os.getenv("HF_TOKEN")
    if env_token:
        return env_token.strip(), "environment_variable"

    raise RuntimeError("No Hugging Face token found.")
```

That gave me a nice balance:

- In the platform, I can keep the Hugging Face token in an asset named `HuggingFace_Token`.
- During local testing, I can fall back to `HF_TOKEN`.
- The output tells me which path was used.

## Calling the model

The actual request block is short. After loading the token, the code creates a Hugging Face `InferenceClient`, sends the user message, and reads the first completion choice.

The project defaults to this model:

```python
DEFAULT_MODEL = "cyberagent/DeepSeek-R1-Distill-Qwen-14B-Japanese:featherless-ai"
```

I liked keeping the model as part of the input contract because it turns the project into a reusable test harness instead of a one-off sample.

Another detail I liked was the `normalize_text` helper. The completion content can come back as a plain string or as a list-like structure, so normalizing it before building the output keeps the return value predictable.

## Why this works well as a base harness

This project is not trying to be a full agentic workflow yet, and that is exactly why it is useful.

- `main()` is the only node, so the runtime shape is easy to understand.
- The generated schema only exposes `message` and `model` on input.
- The output includes `success`, `token_source`, and `error_message`, which makes troubleshooting much easier.
- The dependency list stays small: `uipath>=2.2.0,<2.3.0` and `huggingface-hub>=1.11.0`.

When I want to test connectivity, model behavior, or credential wiring, I would much rather start from something this small than from a larger graph with several moving parts.

## What I would reuse for another external model client

I did not wire a second provider into this repo, but the pattern already feels reusable.

If I wanted to test another external model client next, I would keep these pieces the same:

- the small input and output dataclasses
- the asset-first, environment-second token loading
- the `success` and `error_message` fields for quick debugging
- the optional `model` field so I can change the target model without touching the contract

Then I would swap only the client setup and the request block.

That is the main takeaway I got from this project. The Hugging Face call is useful on its own, but the bigger win is having a clean coded-agent harness that I can reuse when I want to test another model endpoint later.

## What I learned

I found that the hardest part was not the model call itself. It was deciding how much structure to add for a test project. Keeping the function small made the answer obvious.

For this kind of experiment, I think a boring harness is a good thing. One function, one model call, one clear output object. That gives me a solid base before I add tools, branching logic, or a larger workflow.
