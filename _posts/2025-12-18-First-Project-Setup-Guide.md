# UiPath Coded Agent: First Project Setup (Practical Guide)

> **Audience**: AI / ML Engineers exploring *UiPath Coded Agents* with LangChain & LangGraph  
> **Goal**: Build and run your **first production-ready Coded Agent** locally, using the official UiPath SDK

---

## Why Coded Agents (and Why This Matters)

UiPath Coded Agents are **not** just another SDK wrapper.
They represent a shift from:

- Rule-based RPA
- Single-prompt LLM usage

➡️ **Agentic, stateful, enterprise-grade AI systems**

Key characteristics:
- LangGraph-based execution model
- Secure authentication via UiPath Identity
- Native integration with Orchestrator, Data Service, Queues
- Designed for **real production workloads**, not demos

This guide documents my *first clean setup* — the baseline I now reuse for all Coded Agent projects.

---

## 1. Environment Setup

### Python Virtual Environment (Windows / macOS)

#### Windows (PowerShell)

```powershell
python -m venv .venv
.venv\Scripts\Activate
```

#### macOS / Linux (bash / zsh)

```bash
python3 -m venv .venv
source .venv/bin/activate
```

> Always confirm the virtual environment is active before installing dependencies.

---


### Dependency Manager (Optional but Recommended)

```powershell
uv --version
```

`uv` dramatically improves install speed and dependency resolution. Not required, but helpful.

---

## 2. Install UiPath LangChain SDK

```powershell
pip install uipath-langchain
```

This single package brings:
- UiPath SDK
- LangChain
- LangGraph
- MCP adapters
- Instrumentation hooks

No manual wiring required.

---

## 3. Verify UiPath CLI

```powershell
uipath --version
```

You should see a valid version (e.g. `2.x.x`). If not, the CLI is not on PATH.

---

## 4. Authenticate (Staging Recommended)

```powershell
uipath auth --staging
```

What happens here:
- Browser-based OAuth
- Tenant selection
- Local token stored securely

> 💡 Use **staging** while learning. It mirrors production behavior without risk.

---

## 5. Create a New Coded Agent Project

```powershell
uipath new my-agent
```

This generates the **agent skeleton**:

```text
main.py
langgraph.json
pyproject.toml
```

At this point, you have a *valid but uninitialized* project.

---

## 6. Initialize UiPath Project Metadata

```powershell
uipath init
```

This step is crucial. It adds:

```text
uipath.json
bindings.json
entry-points.json
*.mmd (Mermaid diagram)
```

These files allow:
- Studio Web execution
- Orchestrator deployment
- Visual documentation of the agent

---

## 7. Project Structure (Final State)

```text
my-agent/
├─ main.py              # Agent logic
├─ langgraph.json       # State machine definition
├─ pyproject.toml       # Python dependencies
├─ uipath.json          # UiPath project metadata
├─ bindings.json        # Input / Output schema
├─ entry-points.json    # Agent entrypoints
├─ diagram.mmd          # Auto-generated architecture diagram
```

This structure is **non-negotiable** for production agents.

---

## 8. Run the Agent Locally

### Option 1: Run with JSON Input File (Recommended)

Create an input file:

```json
{
  "topic": "UiPath Coded Agent"
}
```

Save it as `input.json`, then run:

```powershell
uipath run agent input.json
```

This approach is:
- Easier to maintain
- Safer for complex inputs
- Closer to real production usage

---

### Option 2: Run with Inline JSON (Quick Test)

```powershell
uipath run agent '{"topic":"UiPath株式会社"}'
```

Use this only for quick validation. File-based input is preferred.

---


## 9. Example: Minimal LangGraph-Based Coded Agent

Below is a **minimal but complete** Coded Agent implemented during this practice.  
It demonstrates how UiPath Coded Agents are fundamentally **LangGraph state machines**, not prompt scripts.

### Agent Goal
- Input: a simple topic (`string`)
- Output: a short generated report

---

### Core Concepts Demonstrated

- UiPath-managed LLM (`UiPathChat`)
- Typed state with Pydantic models
- Async LangGraph node execution
- Explicit `START → END` graph definition

---

### `main.py` (Simplified)

```python
from langchain_core.messages import HumanMessage, SystemMessage
from langgraph.graph import START, StateGraph, END
from uipath_langchain.chat import UiPathChat
from pydantic import BaseModel

# 1. LLM Setup (UiPath LLM Gateway)
llm = UiPathChat(model="gpt-4o-mini-2024-07-18")

# 2. Define State
class GraphState(BaseModel):
    topic: str

class GraphOutput(BaseModel):
    report: str

# 3. Node Definition
async def generate_report(state: GraphState) -> GraphOutput:
    system_prompt = (
        "You are a report generator. "
        "Please provide a brief report based on the given topic."
    )
    output = await llm.ainvoke(
        [SystemMessage(system_prompt), HumanMessage(state.topic)]
    )
    return GraphOutput(report=output.content)

# 4. Build Graph
builder = StateGraph(GraphState, output=GraphOutput)
builder.add_node("generate_report", generate_report)
builder.add_edge(START, "generate_report")
builder.add_edge("generate_report", END)

# 5. Compile Graph
graph = builder.compile()
```

---

### Why This Structure Matters

Even though this agent is simple, it already provides:

- Deterministic execution flow
- Typed input/output contracts
- Easy extension to multi-step workflows

Adding steps such as `classify → decide → execute` only requires **adding nodes and edges**, not rewriting logic.

---

## What I Learned (Important)

- Coded Agents are *not* prompt scripts — they are **state machines**
- LangGraph is the real core, not LangChain
- UiPath handles authentication, infra, and governance extremely well
- Once the skeleton exists, adding tools and LLMs is trivial

---

## 10. Package and Publish the Agent

### Package

```powershell
uipath pack
```

This creates a deployable agent package.

---

### Publish to Orchestrator

```powershell
uipath publish
```

Once published, the agent becomes available in:
- UiPath Orchestrator
- Studio Web
- Enterprise automation workflows