# 🔔 Observers-Hexagonal NOTIFIER - AI Project Context

**Last Updated:** October 8, 2025  
**Current Phase:** Phase 0 - Project Setup & Documentation (Complete)  
**Next Phase:** Phase 1 - Hexagonal Architecture Foundation + MCP Infrastructure  
**Taiga Board:** https://tree.taiga.io/project/frankpulido-notifier/

---

## 🎯 **What Is This Project?**

A **Publisher-Subscriber notification platform** with hexagonal architecture that allows users to:
- Subscribe to content from publishers through topical lists
- Receive notifications via their preferred channels (Alexa, Slack, Discord, WhatsApp, etc.)
- Control their communication preferences without platform lock-in

### **Core Innovation: Username-Based Integration**

Instead of complex OAuth flows, users simply provide usernames for services:
- Alexa: `john@example.com` (Amazon account)
- Slack: `@john.doe`
- Discord: `JohnDoe#1234`
- WhatsApp: `+1234567890`

**Benefits:**
- No OAuth complexity
- User privacy control
- Service independence
- Easy testing

---

## 🏗️ **Technology Stack**

### **Backend**
- **Framework:** Laravel (existing)
- **Architecture:** Hexagonal (DDD)
- **Database:** MySQL/PostgreSQL
- **API:** RESTful

### **Frontend**
- **Framework:** React (Vite)
- **State Management:** TBD
- **UI Library:** TBD

### **Infrastructure**
- **Deployment:** Railway (configured)
- **Containerization:** Docker
- **Version Control:** Git

---

## 📁 **Project Structure**

```
observers-hexagonal/
├── laravel/                              # Docker container for Laravel
│   ├── app/                              # Laravel framework (existing - untouched)
│   │   ├── Models/                       # Existing models (become Infrastructure adapters)
│   │   │   ├── User.php                  # Roles: admin, publisher, subscriber
│   │   │   ├── Publisher.php             # Business entity
│   │   │   ├── PublisherList.php         # Content categories (is_private flag)
│   │   │   ├── Subscriber.php            # User profiles
│   │   │   ├── Subscription.php          # Links subscribers to publisher lists
│   │   │   └── Notification.php          # Multi-type notifications
│   │   ├── Http/Controllers/
│   │   │   └── SubscriberController.php
│   │   ├── Observers/
│   │   │   └── NotificationObserver.php  # Event-driven foundation
│   │   └── Providers/
│   │       └── AppServiceProvider.php
│   │
│   ├── src/ObserversHex/                 # NEW: Hexagonal architecture (to be created)
│   │   ├── Domain/                       # Pure business logic (zero Laravel dependencies)
│   │   │   ├── Publisher/
│   │   │   │   ├── Entities/
│   │   │   │   ├── ValueObjects/
│   │   │   │   ├── Services/
│   │   │   │   └── Repositories/
│   │   │   ├── Subscriber/
│   │   │   ├── Notification/
│   │   │   └── Shared/
│   │   ├── Application/                  # Use cases (framework agnostic)
│   │   │   ├── UseCases/
│   │   │   ├── DTOs/
│   │   │   └── Ports/
│   │   └── Infrastructure/               # Adapters
│   │       ├── Laravel/                  # Laravel-specific adapters
│   │       │   ├── Repositories/
│   │       │   └── Models/
│   │       ├── Alexa/                    # Alexa channel adapter
│   │       └── Persistence/
│   │
│   ├── composer.json                     # Update: "ObserversHex\\": "src/ObserversHex/"
│   └── Dockerfile
│
├── react/                                # Docker container for React frontend
│   ├── src/
│   ├── package.json
│   └── Dockerfile
│
├── php/                                  # Docker container for PHP
│   └── Dockerfile
│
├── nginx/                                # Docker container for Nginx
│   └── conf.d/
│
└── docker-compose.yml                    # Multi-container orchestration
```

**Key Points:**
- `laravel/` is a **Docker container folder**, not just the Laravel app
- `src/ObserversHex/` sits **inside laravel/** but **outside app/** (beside Laravel framework)
- Pure business logic in `src/` has **zero Laravel dependencies**
- Existing `app/Models/` become Infrastructure adapters

---

## 🧠 **Key Architectural Decisions**

### **1. Hexagonal Architecture (Ports & Adapters)**

**Decision:** Build hexagonal architecture ON TOP of existing Laravel models  
**Rationale:**
- Leverage existing models and migrations
- Keep business logic portable and testable
- Enable future microservices evolution
- Framework independence

### **2. Username-Based Channel Integration**

**Decision:** Use usernames instead of OAuth for channel authentication  
**Rationale:**
- Simpler architecture
- Better user privacy
- No token management complexity
- Easier testing

### **3. Publisher List System**

**Decision:** Users subscribe to topical lists, not publishers directly  
**Rationale:**
- Publishers create content categories
- Fine-grained subscription control
- Public/private list distinction
- Better user experience

### **4. Alexa as First Channel**

**Decision:** Start with Alexa voice interface  
**Rationale:**
- Forces true hexagonal thinking
- Voice commands map to use cases
- Clear success criteria
- Different from typical web UI patterns

---

## 📊 **Current State**

### ✅ **What's Done**
- Laravel application structure
- Docker configuration
- Railway deployment setup
- Core models (User, Publisher, PublisherList, Subscriber, Subscription, Notification)
- NotificationObserver foundation
- Basic migrations and seeders
- Comprehensive architectural documentation (README_dev.md)
- Taiga project populated with 30 user stories

### 🚧 **What's In Progress**
- Planning hexagonal architecture with MCP integration
- Finalizing authentication model design

### 📋 **What's Next (Tomorrow - Oct 9)**
**Feature 1: Hexagonal Architecture with MCPs**
- Phase 0: Build hexagonal architecture foundation
- Phase 1: Build first MCP (Alexa) + MCP adapter infrastructure
- Phase 2+: Add more MCPs (Slack, Discord, etc.) - ~3 hours each

**Feature 2: Authentication Model**
- Revisit username-based authentication approach
- Design verification flow (user self-verification)
- Plan `user_service_channels` table implementation

**Documentation Updates Needed:**
- Update `WARP.md` - Add MCP section to Technology Stack
- Update `PROJECT_ROADMAP.md` - Show MCP servers in Phase 1+
- Update `README_dev.md` - Add MCP Architecture section
- Create `ARCHITECTURE_MCP.md` - Detailed MCP design

---

## 💻 **Common Commands**

### **Backend (Laravel)**
```bash
# Navigate to Laravel directory
cd laravel

# Install dependencies
composer install

# Run migrations
php artisan migrate

# Seed database
php artisan db:seed

# Start development server
php artisan serve

# Run tests
php artisan test
```

### **Frontend (React)**
```bash
# Navigate to React directory
cd react

# Install dependencies
npm install

# Start development server
npm run dev

# Build for production
npm run build
```

### **Docker**
```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop all services
docker-compose down

# Rebuild containers
docker-compose up -d --build
```

### **Git Workflow**
```bash
# Check current status
git status

# View recent commits
git log --oneline -10

# Create feature branch
git checkout -b feature/your-feature-name

# Commit with Taiga reference
git commit -m "Feature description TG-123 #in-progress"
```

---

## 🎯 **Domain Model Overview**

### **Aggregates**
- **User**: Authentication + service channels + dual role (publisher/subscriber)
- **Publisher**: Business entity + publisher lists
- **Subscriber**: Profile + subscriptions + demographics
- **Notification**: Content + delivery tracking + multi-channel

### **Value Objects**
- **ServiceChannel**: (service, username, preferences, isActive)
- **NotificationContent**: (title, message, type, formatting)
- **SubscriptionPreferences**: (frequency, channels, content filters)

### **Domain Services**
- **NotificationDispatcher**: Determines which channels to use
- **SubscriptionManager**: Handles public/private list access
- **ChannelVerifier**: Validates usernames across services

---

## 🔄 **Development Workflow**

### **Starting a New Feature**
1. Check Taiga board for current tasks
2. Read relevant documentation
3. Create feature branch
4. Implement in Domain → Application → Infrastructure order
5. Write tests for each layer
6. Update documentation
7. Commit with Taiga reference
8. Create PR

### **Testing Strategy**
- **Domain Layer**: Fast, pure unit tests (no Laravel)
- **Application Layer**: Use case tests with mocked repositories
- **Infrastructure Layer**: Integration tests (Laravel, database, APIs)

---

## ⚠️ **Known Issues & Gotchas**

1. **Railway Deployment**: Dockerfile must be in project root, not laravel/ folder
2. **Models as Adapters**: Existing Laravel models will become infrastructure adapters, not pure domain entities
3. **Dual User Roles**: Users can be both publishers AND subscribers simultaneously

---

## 🔗 **Important Links**

- **Taiga Board**: https://tree.taiga.io/project/frankpulido-notifier/
- **Notion Planning**: [To be added]
- **Railway Deployment**: [To be configured]
- **Repository**: [Current git repository]

---

## 🚀 **Quick Start for New AI Session**

```bash
# 1. Navigate to project
cd ~/Documents/developer/observers-hexagonal

# 2. Check git status
git status
git log --oneline -5

# 3. Read these docs (in order):
# - WARP.md (this file)
# - PROJECT_ROADMAP.md
# - README_dev.md
# - Latest PHASE_*.md

# 4. Check Taiga for current tasks
# https://tree.taiga.io/project/frankpulido-notifier/

# 5. You're ready to code! 🚀
```

---

## 📝 **Notes for AI Assistants**

- This project uses hexagonal architecture - keep Domain layer pure!
- **Username-based integration is a core principle - NO OAuth!**
  - Users provide their own service usernames (email for Alexa, @username for Slack, etc.)
  - Users self-verify by responding to verification codes sent to their devices
  - Application authenticates with services using app credentials (one-time setup)
  - No user OAuth tokens, no token management complexity
- **MCP Architecture Decision:** Using Model Context Protocol servers for channel implementations
  - Each channel (Alexa, Slack, Discord) will be a separate MCP server
  - Language independence (Python for Alexa SDK, Node for Discord, etc.)
  - Estimated ~3-4 hours per channel MCP
  - mcpTaiga experience makes this achievable
- PublisherList is the key entity - users subscribe to lists, not publishers
- Follow the three-layer structure: Domain → Application → Infrastructure
- **CRITICAL:** Always read workflow documentation at session start:
  - `~/Documents/developer/AI assistance/a_workflow_to_work_with_warp/WARP AI BEHAVIOUR GUIDE/`
  - Especially `05_TAIGA_INTEGRATION.md` for GitHub-Taiga commit syntax
- **Taiga Workflow:** Use `TG-123 #closed` syntax in commits for automatic task updates
- Update this file after major milestones

## 📅 **Recent Session Notes**

**October 8, 2025:**
- ✅ Added Taiga integration documentation to workflow system
- ✅ Created `05_TAIGA_INTEGRATION.md` with GitHub-Taiga commit syntax
- ✅ Decided to use MCP architecture for channel implementations
- 📋 Tomorrow: Plan Feature 1 (Hexagonal + MCPs) and Feature 2 (Authentication model)

---

**Built with:** Laravel + React + Hexagonal Architecture  
**Status:** Phase 0 - Setup ⚙️  
**Team:** Frank Pulido + AI Assistant
