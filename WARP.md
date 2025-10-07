# 🔔 Observers-Hexagonal NOTIFIER - AI Project Context

**Last Updated:** October 7, 2025  
**Current Phase:** Phase 0 - Project Setup & Documentation  
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
├── laravel/                    # Laravel backend application
│   ├── app/
│   │   ├── Models/            # Existing Laravel models (become adapters)
│   │   │   ├── User.php       # Roles: admin, publisher, subscriber
│   │   │   ├── Publisher.php  # Business entity
│   │   │   ├── PublisherList.php  # Content categories (is_private flag)
│   │   │   ├── Subscriber.php # User profiles
│   │   │   ├── Subscription.php # Links subscribers to publisher lists
│   │   │   └── Notification.php # Multi-type notifications
│   │   └── Observers/
│   │       └── NotificationObserver.php  # Event-driven foundation
│   └── src/ObserversHex/      # NEW: Hexagonal architecture (to be created)
│       ├── Domain/            # Pure business logic (no Laravel)
│       ├── Application/       # Use cases (framework agnostic)
│       └── Infrastructure/    # Adapters (Laravel integration)
├── react/                     # React frontend
├── php/                       # PHP Docker config
├── docker-compose.yml
└── README_dev.md             # Detailed architecture documentation
```

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
- Setting up hexagonal architecture structure
- Documentation system (this file!)

### 📋 **What's Next**
- Create `src/ObserversHex/` directory structure
- Define domain entities
- Implement first use cases
- Build Alexa adapter

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
- Username-based integration is a core principle - no OAuth
- PublisherList is the key entity - users subscribe to lists, not publishers
- Follow the three-layer structure: Domain → Application → Infrastructure
- Update this file after major milestones

---

**Built with:** Laravel + React + Hexagonal Architecture  
**Status:** Phase 0 - Setup ⚙️  
**Team:** Frank Pulido + AI Assistant
