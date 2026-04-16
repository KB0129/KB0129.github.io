---
layout: default
title: "Building a ChatGPT-Style App with the Conversational Agent SDK"
date: 2026-03-23
categories: [UiPath, React, TypeScript]
excerpt: "I built a ChatGPT-like interface for a client project using React and the Conversational Agent SDK. Here's how I set it up and what I learned."
---

# Building a ChatGPT-Style App with the Conversational Agent SDK

I needed to build a conversational AI interface for a client project - something like ChatGPT but integrated with automation workflows. After evaluating a few options, I went with the Conversational Agent SDK because it had good TypeScript support and WebSocket handling built in.

Setup took about a day. Here's what I learned.

## Tech Stack

- **Frontend**: React + TypeScript
- **Build Tool**: Vite
- **SDK**: Conversational Agent SDK
- **UI**: Markdown rendering, syntax highlighting, file upload, theme toggle
- **Communication**: WebSocket (Socket.io)

## Configuration

The trickiest part was getting authentication set up. You need a `.env` file with your cloud credentials:

```env
# Cloud Configuration
VITE_CLOUD_URL=https://cloud.uipath.com
VITE_ORG_ID=your-org-id
VITE_TENANT_ID=your-tenant-id
VITE_AUTH_TOKEN=your-token

# SDK Configuration  
UIPATH_AUTH_TOKEN=your-jwt-token
UIPATH_BASE_URL=https://cloud.uipath.com
UIPATH_TENANT_ID=your-tenant-id
UIPATH_ORG_ID=your-org-id
UIPATH_FOLDER_KEY=your-folder-key

# App URLs
APP_URL=your-app-url
APP_REDIRECT_URI=your-redirect-uri
```

**Important:** Don't commit this file! Add `.env` to your `.gitignore`. I almost made that mistake.

The Vite config is straightforward - I set up path aliases (`@` → `./src`) and configured the dev server for port 3000.

## Development Workflow

After installing the SDK CLI globally, the workflow is pretty simple:

```bash
# 1. Authenticate (first time only)
uipath auth

# 2. Install dependencies
npm install

# 3. Run dev server
npm run dev
```

The dev server runs on port 3000 with hot reload.

## Deployment

Deploying took me a while to figure out. The process is:

```bash
# 1. Build
npm run build

# 2. Register app (first time only)
uipath register app --name your-app-name

# 3. Pack the build
uipath pack dist --name your-app-name --v 1.0.0

# 4. Publish
uipath publish

# 5. Deploy
uipath deploy
```

The CLI handles uploading and configuring everything. Pretty smooth once you get it working.

## Features I Built

The app ended up with a pretty full feature set:

**Chat Interface:**
- WebSocket-based real-time messaging
- Markdown rendering with syntax highlighting
- File upload (drag-and-drop)
- Message history and session management

**UX Details:**
- Light/dark theme toggle
- Connection status indicator
- Loading states for better feedback
- Mobile-responsive layout

**SDK Integration:**
The SDK provides services for:
- Managing conversational agents
- Handling chat interactions  
- Processing real-time events
- Client lifecycle management

I wrapped these in React hooks (`useAuth`, `useAgents`) to make them easier to use in components.

## Project Structure

```
your-app/
├── src/
│   ├── components/
│   │   ├── auth/              # Authentication components
│   │   │   ├── AuthProvider.tsx
│   │   │   ├── LoginScreen.tsx
│   │   │   └── SettingsModal.tsx
│   │   ├── chat/              # Chat interface components
│   │   │   ├── ChatContainer.tsx
│   │   │   ├── MessageBubble.tsx
│   │   │   ├── MessageInput.tsx
│   │   │   ├── MessageList.tsx
│   │   │   ├── MarkdownContent.tsx
│   │   │   ├── MessageActions.tsx
│   │   │   ├── MultiFileUpload.tsx
│   │   │   ├── AgentStatusBar.tsx
│   │   │   └── ToolCallIndicator.tsx
│   │   ├── common/            # Shared components
│   │   │   ├── ConnectionStatus.tsx
│   │   │   ├── LoadingSpinner.tsx
│   │   │   └── ThemeToggle.tsx
│   │   ├── layout/            # Layout components
│   │   │   └── ChatLayout.tsx
│   │   └── session/           # Session management
│   │       └── SessionSidebar.tsx
│   ├── services/              # SDK services
│   │   └── sdk/
│   │       ├── AgentService.ts
│   │       ├── ConversationService.ts
│   │       ├── EventService.ts
│   │       └── SDKClientManager.ts
│   ├── hooks/                 # Custom React hooks
│   │   ├── useAuth.ts
│   │   └── useAgents.ts
│   ├── types/                 # TypeScript type definitions
│   ├── utils/                 # Utility functions
│   ├── App.tsx                # Main app component
│   ├── main.tsx               # Application entry point
│   ├── index.css              # Global styles
│   └── chatgpt-style.css      # Chat-specific styles
├── .uipath/
│   └── app.config.json        # UiPath app configuration
├── .env                       # Environment variables
├── vite.config.ts            # Vite configuration
├── package.json              # Dependencies
└── tsconfig.json             # TypeScript configuration
```

## Gotchas I Ran Into

A few things that tripped me up:

1. **Token Expiration**: Auth tokens expire. I had to add refresh logic to handle this gracefully instead of just failing.

2. **WebSocket CORS**: The WebSocket connection needed CORS configuration on the server side. This took me an hour to debug.

3. **Type Definitions**: Some SDK types weren't exported properly. I ended up declaring a few custom types in my `types/` folder.

4. **Production Build**: The production build uses tree-shaking. Make sure you're not importing things that get shaken out at runtime.

## Key Dependencies

Here are the main packages I used:

**Core:**
- `@uipath/conversational-agent-sdk` - The SDK itself
- `react` / `react-dom` - UI framework
- `socket.io-client` - WebSocket handling

**UI & Content:**
- `react-markdown` - Markdown rendering
- `highlight.js` - Code syntax highlighting  
- `react-dropzone` - File uploads
- `html-to-image` - Export chat to image

## What I Learned

This was my first time using the Conversational Agent SDK. The TypeScript types were helpful, but I wish there were more examples in the docs. The WebSocket integration was smoother than I expected.

If you're building something similar, the SDK saves a lot of time on the agent orchestration and event handling. You can focus on the UI instead of reinventing that wheel.

Full code structure and examples are on [my GitHub](https://github.com/KB0129).
