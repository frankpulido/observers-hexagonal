# MCP Strategy Discussion

**Source:** https://nine-yogurt-e7b.notion.site/10-Hexagonal-MCPs-2864893773ea8015bee4eebe0fabfd30  
**Date:** October 9, 2025

---

## Core Concept

Using MCPs (Model Context Protocol servers) as the "microservices" for each notification channel.

---

## Why MCPs Would Be Perfect

### 1. Natural Fit for Hexagonal Architecture

```
Core Laravel App (Domain + Application)
↓ (calls via MCP protocol)
┌────┴────┬────────┬──────────┬──────────┐
↓         ↓        ↓          ↓          ↓
Alexa    Slack  Discord  Telegram  Home Assistant
MCP      MCP      MCP      MCP          MCP
```

### 2. Benefits

- ✅ **Language Independence** - Each MCP can be in optimal language (Python for Alexa/AI, Go for Slack, etc.)
- ✅ **True Isolation** - MCPs run as separate processes
- ✅ **Easy Testing** - Mock MCP responses
- ✅ **Standard Protocol** - Well-defined communication
- ✅ **You Already Know How** - You built mcpTaiga!

### 3. Username-Based Integration = Perfect for MCPs

```php
// Laravel calls MCP
$alexaMcp->sendNotification([
    'username' => '[email protected]',
    'message' => 'New notification from TechCorp'
]);
```

### 4. Evolution Path

- **Phase 1-2:** Core Laravel app + Alexa MCP
- **Phase 3:** Add more MCPs (Slack, Discord, Telegram)
- **Phase 4+:** MCPs can be deployed anywhere, called over network

---

## Architecture Structure

```
laravel/
├── src/ObserversHex/
│   ├── Domain/
│   ├── Application/
│   └── Infrastructure/
│       ├── Laravel/
│       └── MCP/                    # NEW: MCP adapters
│           ├── MCPClient.php
│           ├── AlexaMCPAdapter.php
│           └── SlackMCPAdapter.php

mcp-servers/                        # Separate project
├── mcp-alexa/
├── mcp-slack/
├── mcp-discord/
├── mcp-telegram/
└── mcp-home-assistant/
```

---

## What MCPs Will Do

The "microservices" (MCP servers) will essentially be **thin adapters** whose sole job is:

1. Translate from our domain language → channel API specifics
2. Call the channel's API (Alexa, Slack, Discord, Telegram, Home Assistant)
3. Return success/failure status back to our core app

**Note:** Implemented channels (Oct 17, 2025): Alexa, Discord, Home Assistant, Slack, Telegram

### Data Flow

```
┌─────────────────────────────────────────────┐
│ Laravel Core (Hexagonal Architecture)       │
│                                             │
│ Domain: NotificationDispatcher decides      │
│         "Send to user's Alexa"              │
│         ↓                                   │
│ Application: SendNotificationUseCase        │
│         ↓                                   │
│ Infrastructure: AlexaMCPAdapter             │
└──────────────────┬──────────────────────────┘
                   │ MCP Protocol
                   ↓
┌─────────────────────────────────────────────┐
│ MCP Server: mcp-alexa                       │
│                                             │
│ - Receives: (username, message, title)      │
│ - Calls: Amazon Alexa Notify API            │
│ - Returns: {success: true, messageId}       │
└─────────────────────────────────────────────┘
```

---

## Key Insights

1. **MCPs are thin adapters** - They don't contain business logic, just API translation
2. **Domain logic stays in Laravel** - NotificationDispatcher, use cases, etc.
3. **Protocol-based communication** - Standardized MCP protocol for all channels
4. **Independent deployment** - Each MCP can run separately and scale independently
5. **Language flexibility** - Use the best tool for each channel's SDK

---

## Questions to Address

1. **Authentication Flow:**
   - Where do channel app credentials live? (In MCP servers)
   - How does username verification work across MCPs?
   
2. **MCP Communication:**
   - Local stdio initially?
   - Network-based for production?
   
3. **Error Handling:**
   - How do MCPs report detailed failures?
   - Retry logic in Laravel or MCP?

4. **Database Schema:**
   - `subscriber_service_channels` table (implemented Oct 17) is MCP-ready
   - Verification state stored in `verification_token`, `verified_at`, `is_active` columns
   - No schema changes needed for MCP transition
