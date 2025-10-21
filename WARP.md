# 🔔 Observers-Hexagonal NOTIFIER - AI Project Context

**Last Updated:** October 17, 2025  
**Current Phase:** Phase 1 - Registration Foundation (Partial Complete)  
**Next Phase:** Phase 1 (Continued) - Hexagonal Architecture Structure  
**Taiga Board:** https://tree.taiga.io/project/frankpulido-notifier/

---

## 🎯 **What Is This Project?**

A **Publisher-Subscriber notification platform** with hexagonal architecture that allows users to:
- Subscribe to content from publishers through topical lists
- Receive notifications via their preferred channels (Alexa, Slack, Discord, Telegram, Home Assistant)
- Control their communication preferences without platform lock-in

### **Core Innovation: Username-Based Integration**

Instead of complex OAuth flows, users simply provide usernames for services:
- Alexa: `john@example.com` (Amazon account)
- Slack: `@john.doe`
- Discord: `JohnDoe#1234`
- Telegram: `+1234567890`
- Home Assistant: `user@example.com`

**Benefits:**
- No OAuth complexity
- User privacy control
- Service independence
- Easy testing
- GDPR compliant by design

---

## 🏗️ **Technology Stack**

### **Backend**
- **Framework:** Laravel 12.31.1
- **Architecture:** Hexagonal (DDD)
- **Database:** MySQL
- **API:** RESTful

### **Frontend**
- **Framework:** React (Vite)
- **State Management:** TBD
- **UI Library:** TBD

### **Infrastructure**
- **Deployment:** Railway (configured)
- **Containerization:** Docker
- **Version Control:** Git
- **Future:** MCP servers for channel microservices

---

## 📁 **Project Structure**

```
observers-hexagonal/
├── laravel/                              # Docker container for Laravel
│   ├── app/                              # Laravel framework
│   │   ├── Models/                       # Infrastructure adapters
│   │   │   ├── User.php                  # Auth + dual role (ObservedBy UserObserver)
│   │   │   ├── Publisher.php             # Business entity
│   │   │   ├── PublisherList.php         # Content categories (is_private flag)
│   │   │   ├── Subscriber.php            # User profiles (ObservedBy SubscriberObserver)
│   │   │   ├── Subscription.php          # Links subscribers to publisher lists
│   │   │   ├── Notification.php          # Multi-type notifications
│   │   │   ├── ServiceChannel.php        # Channel types (ObservedBy ServiceChannelObserver)
│   │   │   └── SubscriberServiceChannel.php # Full model (not pivot)
│   │   ├── Http/Controllers/
│   │   │   └── SubscriberController.php
│   │   ├── Observers/                    # Infrastructure automation
│   │   │   ├── UserObserver.php          # Creates Subscriber
│   │   │   ├── SubscriberObserver.php    # Creates SubscriberServiceChannels
│   │   │   ├── ServiceChannelObserver.php # Creates SubscriberServiceChannels
│   │   │   └── NotificationObserver.php  # Event-driven foundation
│   │   └── Providers/
│   │       └── AppServiceProvider.php
│   │
│   ├── src/ObserversHex/                 # NEW: Hexagonal architecture (to be created)
│   │   ├── Domain/                       # Pure business logic (zero Laravel dependencies)
│   │   │   ├── Subscriber/
│   │   │   │   ├── Entities/
│   │   │   │   ├── ValueObjects/
│   │   │   │   ├── Services/
│   │   │   │   └── Repositories/
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
- Observer chain ensures automatic data consistency

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
- GDPR compliant (user self-verification)

### **3. Subscriber-Centric Channel Management**

**Decision:** SubscriberServiceChannel as full model (not pivot table)  
**Rationale:**
- Supports rich behavior (verification tokens, timestamps, activation state)
- Cleaner domain separation (User = auth, Subscriber = notifications)
- Observer-driven creation ensures data consistency
- Future-proof for MCP transition

### **4. Observer Pattern for Infrastructure**

**Decision:** Use Laravel Observers for automatic data consistency  
**Rationale:**
- Infrastructure automation, not domain logic
- Ensures data consistency without manual linking
- Clean separation of concerns
- Easy to test

### **5. Boot Functions + Database Defaults**

**Decision:** Layered defense for business rules  
**Rationale:**
- Boot functions = explicit business rules in code
- Database defaults = safety net
- Easier future extraction to domain layer

### **6. Alexa as First Channel**

**Decision:** Start with Alexa voice interface  
**Rationale:**
- Forces true hexagonal thinking
- Voice commands map to use cases
- Clear success criteria
- Different from typical web UI patterns

---

## 📊 **Current State**

### ✅ **What's Done**

**Phase 0 (Complete):**
- Laravel application structure
- Docker configuration
- Railway deployment setup
- Taiga project populated with 30 user stories
- Comprehensive architectural documentation

**Phase 1 - Registration Foundation (Complete):**
- ✅ Database schema finalized and validated
  - `service_channels` table (5 channels seeded)
  - `subscriber_service_channels` table (full model)
  - Fixed migration issues (index name length, nullable fields)
- ✅ Observer chain complete (bidirectional sync)
  - UserObserver → creates Subscriber
  - SubscriberObserver → creates SubscriberServiceChannels
  - ServiceChannelObserver → creates SubscriberServiceChannels
- ✅ Model boot functions (explicit business rules)
  - Subscriber: `is_active = false`
  - SubscriberServiceChannel: `is_active = false`
- ✅ Seeders working (correct execution order validated)
- ✅ Comprehensive documentation
  - ARCHITECTURE_REGISTRATION_FLOW.md (776 lines)
  - PHASE_1_REGISTRATION_FOUNDATION.md
  - PROJECT_EVOLUTION_ANALYSIS_UPDATED.md

### 🚧 **What's In Progress**
- Phase 1 continuation: Hexagonal structure creation

### 📋 **What's Next (Tomorrow - Oct 18)**

**Phase 1 Continuation: Hexagonal Architecture Structure**
1. Create `laravel/src/ObserversHex/` directory structure
2. Update `composer.json` with ObserversHex namespace
3. Run `composer dump-autoload`
4. Implement first domain entity (Subscriber value object)
5. Create first use case (ActivateChannelUseCase)
6. Write first domain test

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

# Fresh migration + seed
php artisan migrate:fresh --seed

# Seed database only
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
- **User**: Authentication + dual role (publisher/subscriber)
- **Publisher**: Business entity + publisher lists
- **Subscriber**: Profile + subscriptions + channel management
- **Notification**: Content + delivery tracking + multi-channel

### **Current Entities (Laravel Models)**
- User (with UserObserver)
- Subscriber (with SubscriberObserver + boot function)
- Publisher
- PublisherList
- Subscription
- Notification
- ServiceChannel (with ServiceChannelObserver)
- SubscriberServiceChannel (with boot function)

### **Value Objects (To Be Created in Domain Layer)**
- **ServiceChannel**: (channelId, name, isActive)
- **VerificationToken**: (token, expiresAt)
- **NotificationContent**: (title, message, type, formatting)
- **SubscriptionPreferences**: (frequency, channels, content filters)

### **Domain Services (To Be Created)**
- **NotificationDispatcher**: Determines which channels to use
- **SubscriptionManager**: Handles public/private list access
- **ChannelVerificationService**: Validates usernames across services

---

## 🔄 **Development Workflow**

### **Starting a New Feature**
1. Check Taiga board for current tasks
2. Read relevant documentation (WARP.md, PROJECT_ROADMAP.md, latest PHASE_*.md)
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
2. **Models as Adapters**: Existing Laravel models are infrastructure adapters, not pure domain entities
3. **Dual User Roles**: Users can be both publishers AND subscribers simultaneously
4. **MySQL Index Names**: Must be ≤64 characters (use custom short names)
5. **Seeder Order Matters**: ServiceChannels must be created before Users (observer chain dependency)
6. **Observer Chain**: Infrastructure automation, not domain logic - will be extracted when building hexagonal layer

---

## 🔗 **Important Links**

- **Taiga Board**: https://tree.taiga.io/project/frankpulido-notifier/
- **Notion Planning**: https://nine-yogurt-e7b.notion.site/v2-Project-Notifier-Publisher-Subscriber-27a4893773ea800eabb0f255c5b3286c
- **Railway Deployment**: https://observers-hexagonal-production-99d3.up.railway.app ✅ Live
- **Repository**: https://github.com/frankpulido/observers-hexagonal

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
# - PHASE_1_REGISTRATION_FOUNDATION.md (latest)
# - ARCHITECTURE_REGISTRATION_FLOW.md (comprehensive rationale)

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
  - Current schema is MCP-ready (no breaking changes needed for transition)
- **Observer Pattern:** Infrastructure automation, not domain logic
  - UserObserver → SubscriberObserver → ServiceChannelObserver
  - Ensures data consistency without manual linking
  - Will be replaced by explicit domain services in hexagonal layer
- **Boot Functions:** Make business rules explicit in code
  - Layered defense with database defaults
  - Easier to extract to domain layer later
- PublisherList is the key entity - users subscribe to lists, not publishers
- Follow the three-layer structure: Domain → Application → Infrastructure
- **CRITICAL:** Always read workflow documentation at session start:
  - `~/Documents/developer/AI assistance/a_workflow_to_work_with_warp/WARP AI BEHAVIOUR GUIDE/`
  - Especially `05_TAIGA_INTEGRATION.md` for GitHub-Taiga commit syntax
- **Taiga Workflow:** Use `TG-123 #closed` syntax in commits for automatic task updates
- Update this file after major milestones

---

## 📅 **Recent Session Notes**

**October 8, 2025:**
- ✅ Added Taiga integration documentation to workflow system
- ✅ Created `05_TAIGA_INTEGRATION.md` with GitHub-Taiga commit syntax
- ✅ Decided to use MCP architecture for channel implementations
- 📋 Plan Feature 1 (Hexagonal + MCPs) and Feature 2 (Authentication model)

**October 17, 2025:**
- ✅ **Registration Foundation Complete (Phase 1 Partial)**
  - Built complete observer chain:
    - UserObserver → creates Subscriber on User creation
    - SubscriberObserver → creates SubscriberServiceChannels for all existing ServiceChannels
    - ServiceChannelObserver → creates SubscriberServiceChannels for all existing Subscribers
  - Created `service_channels` table with 5 channels (alexa, discord, home_assistant, slack, telegram)
  - Created `subscriber_service_channels` table as **full model** (not pivot table)
  - Fixed migration issues:
    - Index name too long → used custom short name `sub_svc_chan_unique`
    - Required email/mobile → made nullable for MVP
  - Updated seeders for correct execution order:
    - ServiceChannels FIRST → then Users → then Other seeders
    - This ensures observer chain works correctly
  - Added boot functions to enforce business rules:
    - Subscriber: `is_active = false` (inactive until channel activated)
    - SubscriberServiceChannel: `is_active = false` (inactive until user verifies)
  - Successfully validated with `migrate:fresh` + `db:seed`:
    - 12 users created (2 manual + 10 factory)
    - 12 subscribers created automatically
    - 60 subscriber_service_channels created (12 × 5)
    - Random channel activation for testing
- ✅ **Comprehensive Documentation**
  - Created ARCHITECTURE_REGISTRATION_FLOW.md (776 lines)
    - Complete registration flow design and rationale
    - GDPR compliance strategy
    - Hexagonal architecture alignment
    - MCP integration readiness
    - Security analysis (self-verification brilliance)
    - Future evolution path
  - Created PHASE_1_REGISTRATION_FOUNDATION.md (implementation summary)
  - Updated PROJECT_EVOLUTION_ANALYSIS.md (implementation validation)
- ✅ **Key Architectural Decisions**
  - SubscriberServiceChannel as full model (supports rich behavior)
  - Boot functions + database defaults (layered defense)
  - Seeder order: ServiceChannels → Users → Other (observer chain dependency)
  - Observer pattern as infrastructure automation (not domain logic)
  - Subscriber-centric design (cleaner domain separation)
- ✅ **Schema Validated as MCP-Ready**
  - Current database requires **zero breaking changes** for MCP transition
  - ServiceChannel as entity (not enum) = easier MCP mapping
  - Username stored separately = clean adapter boundaries
- 📋 **Next Session (Oct 18):** Begin hexagonal structure creation

**October 20, 2025:**
- ✅ **Railway Deployment Successful**
  - Application deployed to production: https://observers-hexagonal-production-99d3.up.railway.app
  - **Production architecture:** 4 Railway services
    - observers-hexagonal (PHP-Laravel backend with built-in server)
    - mysql (Railway managed)
    - redis (Railway managed - sessions, cache, queue)
    - frontend (React app - separate service)
  - **Key difference from local dev:** No nginx in production (PHP built-in server + Railway routing)
  - Fixed critical issue: Faker dependency in production
    - Problem: `fake()` function undefined in production (Faker in require-dev only)
    - Solution: Used `Str::random()` in UserFactory instead of `fake()->userName()`
    - Rationale: Seeding should work without Faker dependency in production
  - Deployment logs show successful healthcheck
  - Database migrations and seeders executed successfully
- ✅ **Documentation Comprehensive Review**
  - Read ALL markdown files (14 total)
  - Created DOCUMENT_INCONSISTENCIES_TO_RESOLVE.md (14 issues tracked)
  - Created ARCHITECTURE_CHANNEL_SELECTION.md (rationale for Telegram, Discord, Slack, Alexa, Home Assistant)
  - Fixed Laravel version: 11 → 12.31.1
  - Identified schema name inconsistency: `user_service_channels` vs `subscriber_service_channels` (actual)
  - Documented observer pattern philosophy question for Phase 1b
- ✅ **Channel Selection Validated**
  - Confirmed Telegram > WhatsApp decision (API quality, privacy, cost, MCP effort)
  - Documented technical rationale for all 5 channels
  - Total MCP implementation effort: 20-27 hours for all channels

---

**Built with:** Laravel 12.31.1 + React + Hexagonal Architecture  
**Status:** Phase 1 - Registration Foundation ✅ → Hexagonal Structure 📋  
**Deployment:** ✅ Live on Railway  
**Team:** Frank Pulido + AI Assistant (Warp - Claude 4.5 Sonnet)
