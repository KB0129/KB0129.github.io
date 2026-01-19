---
layout: default
title: "Quickstart Guide: UiPath Coded MCP Servers"
date: 2026-01-19
categories:
  - UiPath
  - Python
  - MCP
tags:
  - UiPath
  - Model Context Protocol
  - Python
  - Tutorial
---

The implementation of Model Context Protocol (MCP) servers in UiPath allows for powerful integrations and context-aware automation. This guide summarizes the steps to set up and run a UiPath Coded MCP Server, based on the [official documentation](https://uipath.github.io/uipath-python/mcp/quick_start/).

## Introduction

A Coded MCP Server bridges the gap between UiPath's ecosystem and the Model Context Protocol, enabling standard interfaces for context provision and tool execution.

## Prerequisites

Before starting, ensure you have the following environment set up:

1.  **Python 3.11 or higher**.
2.  **Package Manager**: `pip` or `uv`.
3.  **UiPath Automation Cloud Account**: With appropriate permissions.
4.  **UiPath Personal Access Token**: Needs Orchestrator API Access scopes.
    - [Token Documentation](https://docs.uipath.com/automation-cloud/automation-cloud/latest/api-guide/personal-access-tokens)

## Creating a New Project

It is recommended to use `uv` for package management.

To initialize a new project and install the SDK:

```bash
uv init
uv add uipath-mcp
```

## Create Your First UiPath Coded MCP Server

You can scaffold a new MCP server using the `uipath` CLI tool.

> **Warning**: The `uipath new` command deletes all previous `.py` files in the current directory.

```bash
uipath new mcp
```

This command generates the following key files:
- `server.py`: The main server logic.
- `mcp.json`: Configuration for the MCP server.
- `pyproject.toml`: Dependency management and project metadata.

## Initialize Project Configuration

Initialize the local configuration files:

```bash
uipath init
```

This will create:
- `.env`: For environment variables (like authentication tokens).
- `uipath.json`: UiPath project configuration.

## Authenticate With UiPath

You need to authenticate to interact with Orchestrator. You can do this easily via the CLI.

For standard production environments:

```bash
uipath auth
```

If you are using a staging environment:

```bash
uipath auth --staging
```

This command will prompt you to log in via your browser. Alternatively, you can manually configure credentials in the `.env` file.

## Run the MCP Server

There are two primary ways to run your server: Locally or on the UiPath Automation Cloud.

### 1. Running Locally (On-Prem)

When running locally, requests are tunneled from UiPath to your machine.

**Steps:**
1.  Set the `UIPATH_FOLDER_PATH` in your `.env` file. You can find this path in your Orchestrator URL or interface.
    ```env
    UIPATH_FOLDER_PATH=<Copied folder path>
    ```
2.  Run the server. It will automatically register itself with your UiPath Orchestrator folder.

**Verification:**
Once running, navigate to the **MCP Servers** tab in your Orchestrator folder. You should see your server listed and be able to inspect its tools.

### 2. Running on UiPath Automation Cloud

Deploying to the cloud ("My Workspace") simplifies configuration by handling machine allocation and permissions automatically.

**Steps:**
1.  **Package Your Project**: Build your project distribution.
2.  **Publish**: Upload the package to UiPath.
3.  **Configure**:
    - Go to **My Workspace** > **MCP Servers** tab.
    - Click **Add MCP Server**.
    - Select **Coded** as the type.
    - Choose your process (e.g., `math-server`).
    - Click **Add**.

Once deployed, the server starts automatically and registers its tools for use by MCP clients (like UiPath Agents or other LLM interfaces).

---

*This post serves as a quick reference. For full details, consult the [UiPath Python MCP documentation](https://uipath.github.io/uipath-python/mcp/quick_start/).*
