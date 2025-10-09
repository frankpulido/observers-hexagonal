# 📑 Project Index - Observers-Hexagonal NOTIFIER

**Last Updated:** October 7, 2025  
**Purpose:** Complete file and directory reference for AI and developers  
**Project Root:** `/Users/frankpulidoalvarez/Documents/developer/observers-hexagonal`

---

## 📚 **Documentation Files (Project Root)**

| File                                | Size      | Purpose                          | Status             |
|-------------------------------------|-----------|----------------------------------|--------------------|
| `WARP.md`                           | 305 lines | AI-first project context         | ✅ Current         |
| `PROJECT_ROADMAP.md`                | 370 lines | Development phases & planning    | ✅ Current         |
| `PROJECT_INDEX.md`                  | This file | Complete project reference       | ✅ Current         |
| `README.md`                         | 220 B.    | User documentation.              | 📋 Needs expansion |
| `README_dev.md`                     | 14 KB     | Technical architecture deep dive | ✅ Current         |
| `README_docker_stack.md`            | 1.6 KB.   | Docker configuration guide.      | ✅ Current         |
| `PHASE_0_IMPLEMENTATION_SUMMARY.md` | 358 lines | Setup phase completion record    | ✅ Complete        |

**Documentation Strategy:** See `/Users/frankpulidoalvarez/Documents/developer/mcp-servers/mcpTAIGA/DOCUMENTATION_STRATEGY.md`

---

## 🏗️ **Project Structure Overview**

```
observers-hexagonal/                                          # Project root
├── 📄 Documentation (root level)
│   ├── WARP.md
│   ├── PROJECT_ROADMAP.md
│   ├── PROJECT_INDEX.md (this file)
│   ├── README.md
│   ├── README_dev.md
│   ├── README_docker_stack.md
│   └── PHASE_0_IMPLEMENTATION_SUMMARY.md
│
├── 🐘 laravel/                                              # Docker container for Laravel
│   ├── app/                                                 # Laravel framework (existing)
│   │   ├── Http/
│   │   │   └── Controllers/
│   │   │       ├── Controller.php
│   │   │       └── SubscriberController.php
│   │   ├── Models/                                          # Existing models (become adapters)
│   │   │   ├── User.php
│   │   │   ├── Publisher.php
│   │   │   ├── PublisherList.php
│   │   │   ├── Subscriber.php
│   │   │   ├── Subscription.php
│   │   │   └── Notification.php
│   │   ├── Observers/
│   │   │   └── NotificationObserver.php
│   │   └── Providers/
│   │       └── AppServiceProvider.php
│   │
│   ├── src/ObserversHex/                                    # 🚧 TO BE CREATED - Hexagonal architecture
│   │   ├── Domain/                                          # Pure business logic (zero Laravel)
│   │   │   ├── Publisher/
│   │   │   │   ├── Entities/
│   │   │   │   │   ├── Publisher.php
│   │   │   │   │   └── PublisherList.php
│   │   │   │   ├── ValueObjects/
│   │   │   │   │   ├── PublisherId.php
│   │   │   │   │   └── CIF.php
│   │   │   │   ├── Services/
│   │   │   │   │   └── PublisherListService.php
│   │   │   │   └── Repositories/
│   │   │   │       └── PublisherRepositoryInterface.php
│   │   │   ├── Subscriber/
│   │   │   │   ├── Entities/
│   │   │   │   ├── ValueObjects/
│   │   │   │   ├── Services/
│   │   │   │   └── Repositories/
│   │   │   ├── Notification/
│   │   │   │   ├── Entities/
│   │   │   │   ├── ValueObjects/
│   │   │   │   ├── Services/
│   │   │   │   └── Repositories/
│   │   │   └── Shared/
│   │   │       └── ValueObjects/
│   │   │
│   │   ├── Application/                                     # Use cases (framework agnostic)
│   │   │   ├── UseCases/
│   │   │   │   ├── GetUserNotificationsUseCase.php
│   │   │   │   ├── SubscribeToPublisherListUseCase.php
│   │   │   │   └── GetPublisherListNotificationsUseCase.php
│   │   │   ├── DTOs/
│   │   │   │   ├── NotificationDTO.php
│   │   │   │   └── SubscriptionDTO.php
│   │   │   └── Ports/
│   │   │       └── NotificationChannelPort.php
│   │   │
│   │   └── Infrastructure/                                  # Adapters
│   │       ├── Laravel/                                     # Laravel-specific adapters
│   │       │   ├── Repositories/
│   │       │   │   ├── LaravelUserRepository.php
│   │       │   │   ├── LaravelPublisherRepository.php
│   │       │   │   └── LaravelNotificationRepository.php
│   │       │   └── Models/
│   │       │       └── (Bridges to app/Models)
│   │       ├── Alexa/                                       # Alexa channel adapter
│   │       │   ├── AlexaSkillController.php
│   │       │   ├── AlexaResponseBuilder.php
│   │       │   └── AlexaVoiceAdapter.php
│   │       └── Persistence/
│   │           └── InMemory/                                # For testing
│   │
│   ├── bootstrap/
│   │   ├── app.php
│   │   └── providers.php
│   │
│   ├── config/                                              # Laravel configuration
│   │   ├── app.php
│   │   ├── auth.php
│   │   ├── database.php
│   │   ├── sanctum.php
│   │   └── ...
│   │
│   ├── database/
│   │   ├── migrations/
│   │   ├── seeders/
│   │   └── factories/
│   │
│   ├── public/
│   │   └── index.php
│   │
│   ├── routes/
│   │   ├── api.php
│   │   ├── console.php
│   │   └── web.php
│   │
│   ├── tests/
│   │   ├── Unit/
│   │   │   └── src/                                         # Tests for src/ (no Laravel)
│   │   └── Feature/
│   │       └── app/                                         # Laravel integration tests
│   │
│   ├── composer.json                                        # Update: "ObserversHex\\": "src/ObserversHex/"
│   ├── package.json
│   ├── vite.config.js
│   └── Dockerfile
│
├── ⚛️ react/                                                # Docker container for React
│   ├── src/
│   ├── public/
│   ├── package.json
│   ├── vite.config.js
│   ├── index.html
│   └── Dockerfile
│
├── 🐳 php/                                                  # Docker container for PHP
│   └── Dockerfile
│
├── 🌐 nginx/                                                # Docker container for Nginx
│   └── conf.d/
│
└── docker-compose.yml                                       # Multi-container orchestration
```

---

## 📦 **Key Files Detail**

### **Backend (Laravel)**

#### **Models** (`laravel/app/Models/`)

| File                | Lines | Purpose                          | Key Relations                               |
|---------------------|-------|----------------------------------|---------------------------------------------|
| `User.php`          | ~50   | Authentication & user management | hasOne: Publisher, Subscriber               |
| `Publisher.php`     | 44    | Business entity profile          | belongsTo: User; hasMany: PublisherList     |
| `PublisherList.php` | 37    | Content categories (topics)      | belongsTo: Publisher; hasMany: Subscription |
| `Subscriber.php`    | ~40   | User subscription profile        | belongsTo: User; hasMany: Subscription      |
| `Subscription.php`  | ~35   | Links subscribers to lists       | belongsTo: Subscriber, PublisherList        |
| `Notification.php`  | ~40   | Multi-channel notifications      | Types: in-app, SMS, mail, push              |

**Domain Model:**
```
User ──┬── Publisher ── PublisherList ──┐
       │                                │
       └── Subscriber ──────────── Subscription
                                        │
                                   Notification
```

#### **Controllers** (`laravel/app/Http/Controllers/`)

| File                       | Purpose               | Status      |
|----------------------------|-----------------------|-------------|
| `Controller.php`           | Base controller       | ✅ Existing |
| `SubscriberController.php` | Subscriber management | ✅ Existing |

#### **Observers** (`laravel/app/Observers/`)

| File                       | Purpose                     | Events.                   |
|----------------------------|-----------------------------|---------------------------|
| `NotificationObserver.php` | Notification event handling | created, updated, deleted |

#### **Configuration** (`laravel/`)

| File | Purpose | Status |
|------------------|------------------------------|---------------------------------|
| `composer.json`  | PHP dependencies & autoload  | 📋 Needs ObserversHex namespace |
| `package.json`.  | Frontend build dependencies  | ✅ Current                      |
| `vite.config.js` | Frontend build configuration | ✅ Current                      |
| `Dockerfile`     | Laravel container definition | ✅ Current                      |

---

### **Frontend (React)**

#### **React App** (`react/`)

| File             | Purpose                    | Status.    |
|------------------|----------------------------|------------|
| `package.json`.  | React dependencies         | ✅ Current |
| `vite.config.js` | Vite build configuration.  | ✅ Current |
| `index.html`     | App entry point            | ✅ Current |
| `Dockerfile`.    | React container definition | ✅ Current |

**Status:** Basic structure, needs implementation

---

### **Infrastructure (Docker)**

#### **Docker Configuration** (`/`)

| File                 | Purpose                       | Status     |
|----------------------|-------------------------------|------------|
| `docker-compose.yml` | Multi-container orchestration | ✅ Current |
| `php/Dockerfile`     | PHP environment               | ✅ Current |
| `laravel/Dockerfile` | Laravel-specific setup        | ✅ Current |
| `react/Dockerfile`   | React build container         | ✅ Current |

**Containers:**
1. **laravel** - Backend application
2. **react** - Frontend application
3. **php** - PHP runtime
4. **nginx** - Web server
5. (Implied) **mysql** or **postgres** - Database

---

## 🎯 **Domain Model Overview**

### **Core Entities**

```php
// User (Authentication + Dual Role)
User {
    id, name, email, password
    role: 'admin' | 'publisher' | 'subscriber'
    → hasOne Publisher
    → hasOne Subscriber
}

// Publisher (Business Entity)
Publisher {
    id, user_id, name, cif, address, city, postal_code
    max_private_subscribers_plan
    is_active
    → hasMany PublisherList
}

// PublisherList (Topical Content Categories)
PublisherList {
    id, publisher_id, name, description
    is_private  // ← Key feature!
    is_active
    → hasMany Subscription
}

// Subscriber (User Profile)
Subscriber {
    id, user_id, demographics, occupation
    → hasMany Subscription
}

// Subscription (Subscriber ↔ List Link)
Subscription {
    id, subscriber_id, publisher_list_id
    status, subscribed_at
}

// Notification (Multi-Channel)
Notification {
    id, type, title, message
    type: 'in-app' | 'SMS' | 'mail' | 'push'
}
```

---

## 🔧 **Technology Stack**

### **Backend**
- **Framework:** Laravel 12.0
- **PHP:** 8.2+
- **Authentication:** Laravel Sanctum 4.0
- **Database:** MySQL/PostgreSQL (TBD)
- **Architecture:** Hexagonal (Ports & Adapters)

### **Frontend**
- **Framework:** React
- **Build Tool:** Vite
- **Language:** JavaScript (TypeScript TBD)
- **State Management:** TBD

### **Infrastructure**
- **Containerization:** Docker + Docker Compose
- **Deployment:** Railway
- **Version Control:** Git
- **Web Server:** Nginx

---

## 📋 **Development Status**

### **✅ Phase 0 Complete**
- Laravel application structure
- Core models with relationships
- Database migrations
- Docker configuration (5 containers)
- Railway deployment setup
- Taiga project populated (30 user stories)
- Comprehensive documentation system
- Structure clarification complete

### **📋 Phase 1 Next (Current Sprint)**
- Create `laravel/src/ObserversHex/` directory structure
- Update `laravel/composer.json` autoload
- Implement first domain entity (Publisher)
- Create first use case
- Set up domain testing

---

## 🔗 **Important Links**

- **Taiga Board:** https://tree.taiga.io/project/frankpulido-notifier/
- **Notion Planning:** https://nine-yogurt-e7b.notion.site/v2-Project-Notifier-Publisher-Subscriber-27a4893773ea800eabb0f255c5b3286c
- **Documentation Strategy:** `/Users/frankpulidoalvarez/Documents/developer/mcp-servers/mcpTAIGA/DOCUMENTATION_STRATEGY.md`
- **Railway Deployment:** [To be configured]

---

## 📁 **File Counts & Statistics**

```
Documentation:           7 files (~1,900 lines)
Laravel Models:          6 files
Laravel Controllers:     2 files  
Laravel Observers:       1 file
Configuration Files:     ~15 files
React App:               Basic structure
Docker Files:            5 containers

Total Project Files:     ~500+ files (including vendor/node_modules)
Core Application Files:  ~50 files (excluding dependencies)
```

---

## 🚀 **Quick Navigation**

### **For AI Assistants:**
1. Read `WARP.md` - Project context
2. Check `PROJECT_ROADMAP.md` - Current phase
3. Review `README_dev.md` - Architecture decisions
4. Use this file - File locations

### **For Developers:**
1. Read `README.md` - Getting started
2. Check `README_dev.md` - Technical details
3. Review `README_docker_stack.md` - Local setup
4. Use this file - Code navigation

### **For Project Management:**
1. View Taiga board - Task tracking
2. Check `PROJECT_ROADMAP.md` - Progress
3. Review `PHASE_*.md` - Completion records

---

## 🔍 **Common Operations**

### **Find Files**
```bash
# Find all models
find laravel/app/Models -name "*.php"

# Find all documentation
ls -lah *.md

# Search in documentation
grep -r "hexagonal" *.md

# List migrations
ls laravel/database/migrations/

# Check routes
cat laravel/routes/api.php
```

### **Navigate Structure**
```bash
# Go to Laravel app
cd laravel/

# Go to models
cd laravel/app/Models/

# Go to documentation
cd . && ls *.md

# Go to hexagonal architecture (once created)
cd laravel/src/ObserversHex/
```

---

## ⚠️ **Important Notes**

1. **laravel/ is a Docker container folder**, not just the Laravel app
2. **src/ObserversHex/** goes inside `laravel/`, beside `app/`, outside Laravel skeleton
3. **Existing app/Models/** will become Infrastructure adapters, not pure domain entities
4. **Zero Laravel dependencies** in `src/ObserversHex/Domain/`
5. **composer.json** must be updated before creating domain entities

---

**This index is maintained manually. Update after major structural changes.**

**Last Updated:** October 7, 2025  
**Maintainer:** Frank Pulido  
**AI Assistant:** Warp (Claude 4.5 Sonnet)
