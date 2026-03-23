---
layout: default
title: "UiPath Conversational Agent Web Application"
date: 2026-03-23
categories: [UiPath, React, TypeScript]
excerpt: "A modern ChatGPT-like web application built with React and UiPath Conversational Agent SDK, enabling AI-powered conversational experiences with UiPath's automation platform."
---

# UiPath Conversational Agent Web Application

A modern ChatGPT-like web application built with React and UiPath Conversational Agent SDK, enabling AI-powered conversational experiences with UiPath's automation platform.

## Overview

This application provides a full-featured chat interface integrated with UiPath's Conversational Agent SDK, allowing users to interact with AI agents that can execute automation workflows and provide intelligent responses.

**Version**: 1.0.2
**App Name**: acn-cs-demo-v4
**App Version**: 1.0.4

## Tech Stack

- **Frontend**: React 18.3.1 + TypeScript 5.9.3
- **Build Tool**: Vite 6.4.1
- **SDK**: UiPath Conversational Agent SDK 0.7.7
- **CLI**: UiPath TypeScript CLI 1.0.0-beta.7
- **UI Features**: Markdown rendering, syntax highlighting, file upload, theme toggle
- **Communication**: WebSocket (Socket.io)

## Configuration

### Required Environment Variables

Create a `.env` file in the root directory with the following variables:

```env
# UiPath Cloud Configuration
VITE_CLOUD_URL=https://staging.uipath.com
VITE_ORG_ID=your-organization-id
VITE_TENANT_ID=your-tenant-id
VITE_ACCESS_TOKEN=your-access-token

# UiPath SDK Configuration
UIPATH_ACCESS_TOKEN=your-jwt-token
UIPATH_BASE_URL=https://staging.uipath.com
UIPATH_TENANT_ID=your-tenant-id
UIPATH_ORG_ID=your-organization-id
UIPATH_TENANT_NAME=your-tenant-name
UIPATH_ORG_NAME=your-org-name
UIPATH_FOLDER_KEY=your-folder-key

# Application URLs
UIPATH_APP_URL=your-app-url
UIPATH_APP_REDIRECT_URI=your-redirect-uri
```

### Configuration Details

| Variable | Description |
|----------|-------------|
| `VITE_CLOUD_URL` | UiPath cloud instance URL (production or staging) |
| `VITE_ORG_ID` | Organization ID from UiPath Cloud (found in URL) |
| `VITE_TENANT_ID` | Tenant ID from Orchestrator settings |
| `VITE_ACCESS_TOKEN` | Pre-obtained access token for authentication |
| `UIPATH_ACCESS_TOKEN` | JWT token for SDK authentication |
| `UIPATH_FOLDER_KEY` | Folder key for resource access |
| `UIPATH_APP_URL` | Production app URL |
| `UIPATH_APP_REDIRECT_URI` | OAuth redirect URI |

### Vite Configuration

The application uses custom Vite configuration ([vite.config.ts](vite.config.ts)):

- **Base Path**: `./` (relative paths for deployment)
- **Dev Server**: Port 3000 with auto-open
- **Path Alias**: `@` → `./src`
- **Output**: `dist` directory with sourcemaps

## UiPath TypeScript SDK Commands

### 1. Install SDK

Install the UiPath TypeScript CLI globally:

```bash
npm i -g "[Zip File Folder Path]"
```

The SDK package is typically named `uipath-ts-cli-1.0.0`.

### 2. Authenticate with UiPath

Authenticate with your UiPath account:

```bash
uipath auth
```

### 3. Build Application

Build your application for production:

```bash
npm run build
```

This runs `tsc && vite build` to compile TypeScript and bundle your application.

### 4. Register Application

Register your application with UiPath:

```bash
npx uipath register app --name [app-name]
# or
uipath register app --name [app-name]
```

### 5. Pack Application

Package the built application:

```bash
npx uipath pack dist --name [app-name] --v [app-version]
# or
uipath pack dist --name [app-name] --v [app-version]
```

### 6. Publish Application

Publish the packaged application:

```bash
npx uipath publish
# or
uipath publish
```

### 7. Deploy/Upgrade Application

Deploy or upgrade your application version:

```bash
npx uipath deploy
# or
uipath deploy
```

## Key Features

### 1. Authentication & Authorization
- OAuth-based authentication with UiPath Cloud
- Secure token management
- Session persistence
- Settings configuration modal

### 2. Conversational Interface
- **Real-time Chat**: WebSocket-based messaging
- **Message Types**: Text, file uploads, markdown rendering
- **Tool Call Indicators**: Visual feedback for agent actions
- **Agent Status Bar**: Real-time agent state monitoring

### 3. Session Management
- **Session Sidebar**: Browse and manage conversation sessions
- **Session History**: Persistent conversation storage
- **Multi-session Support**: Switch between different conversations

### 4. Rich Content Support
- **Markdown Rendering**: Full GitHub-flavored markdown
- **Syntax Highlighting**: Code blocks with highlight.js
- **File Upload**: Multi-file drag-and-drop support
- **Message Actions**: Copy, export, and share messages

### 5. User Experience
- **Theme Toggle**: Light/dark mode support
- **Connection Status**: Real-time connectivity indicator
- **Loading States**: Spinner and progress indicators
- **Responsive Design**: Mobile-friendly layout

### 6. SDK Integration
- **Agent Service**: Manage conversational agents
- **Conversation Service**: Handle chat interactions
- **Event Service**: Process real-time events
- **SDK Client Manager**: Centralized SDK lifecycle management

## Project Structure

```
CAS_SDK_Test/
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
├── sdk/                       # Local SDK packages
│   ├── uipath-conversational-agent-sdk-0.7.7/
│   └── uipath-uipath-ts-cli-1.0.0-beta.7/
├── .env                       # Environment variables
├── vite.config.ts            # Vite configuration
├── package.json              # Dependencies
└── tsconfig.json             # TypeScript configuration
```

## Installation & Development

### Prerequisites

- Node.js (v18 or higher)
- npm or yarn
- UiPath Cloud account
- UiPath TypeScript CLI

### Setup

1. Clone the repository
2. Install dependencies:
   ```bash
   npm install
   ```

3. Configure environment variables in `.env`

4. Install UiPath SDK globally:
   ```bash
   npm i -g "./sdk/uipath-uipath-ts-cli-1.0.0-beta.7/package"
   ```

5. Authenticate with UiPath:
   ```bash
   uipath auth
   ```

### Development

Run the development server:

```bash
npm run dev
```

The application will open at `http://localhost:3000`.

### Build

Build for production:

```bash
npm run build
```

### Type Checking

Check TypeScript types without emitting files:

```bash
npm run type-check
```

## Deployment Workflow

1. **Build** the application:
   ```bash
   npm run build
   ```

2. **Register** (first time only):
   ```bash
   uipath register app --name your-app-name
   ```

3. **Pack** the distribution:
   ```bash
   uipath pack dist --name your-app-name --v 1.0.0
   ```

4. **Publish** to UiPath:
   ```bash
   uipath publish
   ```

5. **Deploy/Upgrade**:
   ```bash
   uipath deploy
   ```

## Important Notes

- The SDK packages are included locally in the `sdk/` directory
- Access tokens expire and need to be refreshed periodically
- The application requires proper UiPath Cloud permissions
- WebSocket connection requires appropriate CORS configuration
- Production builds are optimized with tree-shaking and minification

## Dependencies

### Core Dependencies
- `@uipath/conversational-agent-sdk`: UiPath SDK for conversational agents
- `react` & `react-dom`: UI framework
- `uuid`: Unique identifier generation
- `socket.io-client`: WebSocket communication

### UI & Rendering
- `react-markdown`: Markdown rendering
- `rehype-highlight`: Syntax highlighting for code blocks
- `rehype-raw`: HTML support in markdown
- `remark-gfm`: GitHub-flavored markdown
- `highlight.js`: Code syntax highlighting
- `react-dropzone`: File upload component
- `html-to-image`: Export chat to image

## License

ISC

## Author

UiPath
