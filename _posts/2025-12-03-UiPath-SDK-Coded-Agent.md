---
layout: post
title: "Building & Deploying UiPath Coded Agents: A Technical Walkthrough"
date: 2025-12-03
categories: [UiPath, LangChain]
tags: [uipath, coded-agent, langchain, langgraph]
---

This guide provides a complete end-to-end walkthrough for building a **UiPath Coded Agent** (example: Transcript Summarizer) using Python, LangChain, and the UiPath SDK. It covers the project architecture, command sequence, and UiPath Platform configuration required to deploy the agent on Serverless infrastructure.

---

## 1. Project Architecture & File Structure

When initializing a new Coded Agent project, UiPath generates files that define dependencies, metadata, environment variables, and the agent's runtime behavior.

### Initial Setup

After creating your working directory and Python virtual environment, the structure looks like this:

```
my-agent-project/
├── .venv/                  # Python Virtual Environment
├── main.py                 # Core agent logic (LangGraph workflow & nodes)
├── pyproject.toml          # Metadata & dependency configuration
└── langgraph.json          # LangGraph configuration
```

### After Authentication & Initialization

Running `uipath auth` and `uipath init` adds more platform-aware files:

```
my-agent-project/
├── .env                    # Secrets (UiPath tokens, API keys) — do NOT commit
├── uipath.json             # Input/output schema generated from main.py
├── agent.mmd               # Mermaid diagram of the LangGraph workflow
└── agent.json              # Agent definition metadata
```

### Key File Responsibilities

| File | Description |
|------|-------------|
| `main.py` | Contains the StateGraph, nodes (e.g., download_transcript, summarize), and transitions. |
| `uipath.json` | Schema describing input/output arguments exposed to Orchestrator. |
| `pyproject.toml` | Python project configuration; update authors before packaging. |
| `agent.mmd` | Auto-generated visualization of the workflow graph. |

---

## 2. Command Sequence (End-to-End)

Below is the exact chronological order needed to build, test, and deploy the agent.

### Phase 1: Environment Setup & Project Creation

#### Create & Activate Virtual Environment

```powershell
python -m venv .venv
.venv\Scripts\Activate.ps1
```

#### Install Dependencies

```powershell
pip install uipath-langchain
```

#### Scaffold a New Agent

```powershell
uipath new transcript_summarizer
```

---

### Phase 2: Authentication & Configuration

#### Authenticate to UiPath Automation Cloud

```powershell
uipath auth
```

This creates the `.env` file with access tokens.

#### Generate UiPath Schema & Metadata

```powershell
uipath init
```

Run again whenever you modify inputs/outputs in `main.py`.

---

### Phase 3: Local Development & Testing

#### Run the Agent Locally

```powershell
uipath run agent --input '{"bucket_key": "transcripts", "file_path": "meeting_notes.txt"}'
```

#### Development Mode (Live Debugging)

```powershell
uipath dev
```

Provides real-time logs and execution traces of your LangGraph workflow.

---

### Phase 4: Packaging & Deployment

#### Package the Project

```powershell
uipath pack
```

⚠️ **Make sure `authors` is filled in your `pyproject.toml`.**

#### Publish to UiPath Orchestrator

```powershell
uipath publish
```

Choose:
- **0: Tenant Process Feed**

For shared availability across the organization.

---

## 3. Configuring the UiPath Platform (Orchestrator)

Once the package is published, configure UiPath Orchestrator to run it as a Serverless Python Agent.

### 1. Provision a Process

Navigate to:

```
Orchestrator → Shared Folder → Processes → Add Process
```

- Choose your uploaded package (e.g., `transcript_summarizer`)
- Entry point: `agent` or `main`
- Optionally map default arguments (e.g., Storage Bucket names)

---

### 2. Configure Serverless Compute

UiPath Coded Agents run inside a Serverless container.

- Go to **Tenant → Machines**
- Ensure **Cloud Serverless** is available
- Go to **Folder → Machines**
- Assign the Serverless machine to your folder

---

### 3. Setup Robot Access

Agents need identity + permissions to read/write Storage Buckets.

#### Create a Robot Account

```
Tenant → Robots → Add Robot Account
```

- Example name: `coded-agent-robot`
- Set type: **Unattended** (recommended)

#### Assign Folder Permissions

Go to:

```
Folder → Users → Assign User
```

Grant:
- **Automation User** role
- (or a custom role with Storage Bucket + ML Skill permissions)

---

### 4. Execution

Run the job from Orchestrator.

The Serverless runtime will:
1. Spin up a container
2. Install dependencies from `pyproject.toml`
3. Execute your LangGraph workflow
4. Tear down after completion

---

## Resources

- [Video Tutorial — UiPath Coded Agents with LangGraph](https://www.youtube.com/watch?v=your-video-link)
- [UiPath Python SDK Documentation](https://docs.uipath.com/automation-cloud/docs/python-sdk)
- [LangGraph Documentation](https://langchain-ai.github.io/langgraph/)

