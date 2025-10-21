# 🗺️ Observers-Hexagonal NOTIFIER - Project Roadmap

**Last Updated:** October 20, 2025  
**Project Start:** October 2025  
**Current Phase:** Phase 1a Complete ✅ → Phase 1b Next 📋 (Hexagonal Structure)

---

## 📋 **Project Vision**

Build a **platform-agnostic notification system** where:
- Publishers create topical content lists
- Subscribers choose their preferred communication channels
- No vendor lock-in through username-based integration
- Clean hexagonal architecture enables future microservices evolution

---

## 🎯 **Success Criteria**

### **Phase 0 (Setup)**
- ✅ Taiga project populated with tasks
- ✅ Documentation system established
- ✅ Hexagonal architecture approach defined
- ✅ Development workflow operational

### **Phase 1 (Foundation - Split into 1a + 1b)**
- ✅ **Phase 1a:** Registration foundation (database + observers + seeders)
- 📋 **Phase 1b:** Hexagonal structure (domain entities, use cases, repositories)
- 📋 **Phase 1b:** Repository pattern in place
- 📋 **Phase 1b:** Basic tests passing

### **Phase 2 (First Channel)**
- 📋 Alexa adapter working
- 📋 Voice commands functional
- 📋 Username-based integration proven
- 📋 End-to-end flow complete

### **Phase 3 (Multi-Channel)**
- 📋 Slack adapter
- 📋 Discord adapter
- 📋 Telegram adapter
- 📋 Channel independence verified

### **Phase 4 (Production Ready)**
- 📋 Comprehensive test coverage
- 📋 Performance optimization
- 📋 Security hardening
- 📋 Production deployment

---

## 🏗️ **Development Phases**

### **✅ Phase 0: Project Setup & Documentation** *(October 7, 2025)*

**Goals:**
- Establish project structure
- Set up Taiga board
- Create AI-friendly documentation
- Define architectural approach

**Completed:**
- ✅ Taiga project created and populated (30 user stories)
- ✅ Git repository initialized
- ✅ Docker configuration
- ✅ Railway deployment configured
- ✅ README_dev.md with architectural decisions
- ✅ WARP.md (AI context) created
- ✅ PROJECT_ROADMAP.md (this file) created

**Lessons Learned:**
- mcpTaiga tool successfully populated Taiga with git history
- Documentation-first approach pays off for AI-assisted development
- Username-based integration is simpler than OAuth

**Time Spent:** ~2 hours  
**Status:** Complete ✅

---

### **Phase 1: Foundation** *(Started: Oct 17, 2025)*

**Status:** Phase 1a ✅ Complete | Phase 1b 📋 Next  
**Target Completion:** October 24, 2025

---

#### **✅ Phase 1a: Registration Foundation** *(Oct 17, 2025 - COMPLETE)*
- **Database Schema Finalized:**
  - Created `service_channels` table
  - Created `subscriber_service_channels` table (full model, not pivot)
  - Fixed migration issues (index name length, nullable fields)
  - Seeded 5 channels: alexa, discord, home_assistant, slack, telegram
  
- **Observer Chain Implemented (Bidirectional Sync):**
  - UserObserver → creates Subscriber on User creation
  - SubscriberObserver → creates SubscriberServiceChannels for all existing ServiceChannels
  - ServiceChannelObserver → creates SubscriberServiceChannels for all existing Subscribers
  - Result: Automatic data consistency without manual linking
  
- **Model Boot Functions:**
  - Subscriber: `is_active = false` (inactive until channel activated)
  - SubscriberServiceChannel: `is_active = false` (inactive until verified)
  - Layered defense with database defaults as safety net
  
- **Seeders Updated:**
  - Correct execution order: ServiceChannels → Users → Other seeders
  - Random channel activation for testing
  - Validated with `migrate:fresh` + `db:seed`
  - Results: 12 users, 12 subscribers, 60 subscriber_service_channels
  
- **Comprehensive Documentation:**
  - ARCHITECTURE_REGISTRATION_FLOW.md (776 lines comprehensive rationale)
  - PHASE_1_REGISTRATION_FOUNDATION.md (implementation summary)
  - PROJECT_EVOLUTION_ANALYSIS_UPDATED.md (validation of theoretical design)

---

#### **📋 Phase 1b: Hexagonal Structure + MCP Design** *(Next - Target: Oct 24, 2025)*

**Critical Insight:** MCPs (Model Context Protocol servers) are the real architectural challenge that conditions everything else. Features are straightforward Laravel CRUD - the complexity is in the channel communication layer.

**Tasks:**

1. **Create Hexagonal Directory Structure:**
   ```bash
   cd laravel/
   mkdir -p src/ObserversHex/{Domain,Application,Infrastructure}
   mkdir -p src/ObserversHex/Domain/{Subscriber,Shared}
   mkdir -p src/ObserversHex/Domain/Subscriber/{Entities,ValueObjects,Services,Repositories}
   mkdir -p src/ObserversHex/Application/{UseCases,DTOs,Ports}
   mkdir -p src/ObserversHex/Infrastructure/{Laravel,Alexa,Persistence}
   mkdir -p src/ObserversHex/Infrastructure/Laravel/{Repositories,Models}
   ```

2. **Update composer.json:**
   ```json
   {
       "autoload": {
           "psr-4": {
               "App\\": "app/",
               "ObserversHex\\": "src/ObserversHex/"
           }
       }
   }
   ```
   Then run: `composer dump-autoload`

3. **Implement Domain Entities (Pure PHP, zero Laravel):**
   - `ObserversHex\Domain\Subscriber\Entities\Subscriber.php`
   - `ObserversHex\Domain\Subscriber\ValueObjects\SubscriberId.php`
   - `ObserversHex\Domain\Subscriber\ValueObjects\ServiceChannel.php`
   - `ObserversHex\Domain\Subscriber\ValueObjects\VerificationToken.php`

4. **Create First Use Cases:**
   - `ObserversHex\Application\UseCases\ActivateChannelUseCase.php`
   - `ObserversHex\Application\UseCases\VerifyChannelUseCase.php`

5. **Create Repository Interfaces (Ports):**
   - `ObserversHex\Domain\Subscriber\Repositories\SubscriberRepositoryInterface.php`

6. **Create Laravel Repository Adapters:**
   - `ObserversHex\Infrastructure\Laravel\Repositories\LaravelSubscriberRepository.php`
   - Bridges domain layer to Laravel models
   - Translates domain entities ↔ Eloquent models

7. **Design MCP Architecture (Critical):**
   - **MCP Communication Protocol:** stdio vs network, message format
   - **Authentication Strategy:** Where channel credentials live (in MCPs)
   - **Error Handling:** Retry logic, circuit breakers, failure reporting
   - **Deployment Model:** Local development vs production architecture
   - **Document:** Create `ARCHITECTURE_MCP_DETAILED.md` with concrete decisions
   - **Reference:** `docs/STRATEGY_MCP.md` for high-level strategy

8. **Write First Domain Tests:**
   - Test domain entities without Laravel bootstrap
   - Fast, pure unit tests
   - Validate business logic in isolation

**Success Metrics:**
- Domain layer has zero Laravel dependencies
- Use cases can be tested without database
- Repository pattern bridges domain and Laravel models
- **MCP architecture fully designed and documented**
- Ready to build first MCP (Alexa) in Phase 3

**Timeline:** Started Oct 17, targeting completion by Oct 24

---

### **📋 Phase 2: Direct Messaging Feature** *(Target: Week of Oct 28)*

**Note:** This phase implements business logic in Laravel. Actual message delivery will use **mock channel adapters** until MCPs are built in Phase 3.

**Goals:**
- Implement subscriber-to-subscriber direct messaging (business logic)
- Build authorization and privacy model
- Prepare infrastructure for MCP integration
- Complete domain logic without real channel delivery

**Tasks:**
1. **Phase 2.1:** Authorization Foundation
   - Create `authorized_senders` table migration
   - Create `direct_message_log` table migration
   - Build Authorization domain entities
   - Implement AuthorizationService
   
2. **Phase 2.2:** Rate Limiting
   - Implement RateLimitService (20 messages/hour)
   - Add rate limit validation
   - Create delivery log repository
   
3. **Phase 2.3:** Message Sending
   - Build SendDirectMessageUseCase
   - Integrate with NotificationDispatcher
   - Implement delivery logging (metadata only)
   
4. **Phase 2.4:** API & UI
   - Laravel API routes and controllers
   - React authorization management UI
   - Message sending interface
   - Message history views

**Success Metrics:**
- Subscriber can authorize other subscribers
- Messages delivered via subscriber's chosen channel
- Sender sees only success/failure (privacy preserved)
- Rate limiting prevents spam (20/hour)
- No message content stored

**Success Note:** Phase 2 builds the feature logic. Real message delivery happens when MCPs are built in Phase 3+.

**Status:** Design Complete ✅ | Implementation 📋  
**Design Doc:** `docs/FEATURE_SUBSCRIBER_DIRECT_MESSAGING.md`  
**Estimated Time:** 23-31 hours (business logic only, mock delivery)

---

### **📋 Phase 3: First MCP - Alexa Channel** *(Target: Week of Nov 4)*

**🔥 CRITICAL PHASE:** This validates the entire MCP architecture. Once Alexa MCP works, all other channels follow the same pattern.

**Goals:**
- Build first MCP server (`mcp-alexa`) following Phase 1b design
- Implement Laravel MCP adapter (AlexaMCPAdapter)
- Test username-based verification
- **Validate direct messaging works end-to-end**

**Tasks:**
1. **MCP Server (Python):**
   - Create `mcp-servers/mcp-alexa/` project
   - Implement Alexa Notify API integration
   - Handle MCP protocol (stdin/stdout or HTTP)
   - Store channel app credentials in MCP
   
2. **Laravel Integration:**
   - Build `ObserversHex\Infrastructure\MCP\AlexaMCPAdapter.php`
   - Implement MCP client communication
   - Connect SendDirectMessageUseCase → AlexaMCPAdapter
   
3. **Alexa Skill:**
   - Configure Alexa skill
   - Voice commands for direct messaging:
     - "Alexa, send a message to [username]"
     - "Alexa, read my messages"
     
4. **Testing:**
   - Username verification flow
   - End-to-end message delivery
   - Error handling and retry logic

**Success Metrics:**
- 🎯 **Alexa MCP server works independently**
- 🎯 **Laravel ↔️ MCP communication proven**
- Voice commands trigger correct use cases
- Direct messages reach Alexa devices
- Username-based approach validated
- Message privacy preserved
- **Pattern validated for remaining 4 channels**

**Status:** Blocked by Phase 1b (MCP design) 📋  
**Estimated Time:** 15-20 hours (includes MCP learning curve)

---

### **📋 Phase 4: Multi-Channel Expansion (4 More MCPs)** *(Target: Week of Nov 11)*

**Note:** With Alexa MCP pattern proven, these are incremental ~3-4 hours each.

**Goals:**
- Build remaining 4 MCP servers following Alexa pattern
- Verify channel independence
- Test parallel notification delivery

**Tasks:**
1. **Build MCP Servers** (~3-4 hours each):
   - `mcp-slack/` (Python or Go)
   - `mcp-discord/` (Node.js)
   - `mcp-telegram/` (Python)
   - `mcp-home-assistant/` (Python)
   
2. **Laravel MCP Adapters:**
   - SlackMCPAdapter
   - DiscordMCPAdapter
   - TelegramMCPAdapter
   - HomeAssistantMCPAdapter
   
3. **Testing:**
   - Multi-channel direct messaging
   - Verify privacy model across all channels
   - Parallel delivery to multiple channels

**Success Metrics:**
- All 5 MCP servers operational
- Adding new channel doesn't affect existing ones
- User can receive messages on any authorized channel
- Each MCP is completely isolated
- All 5 channels working independently

**Status:** Not Started 📋  
**Estimated Time:** 12-16 hours (4 channels × 3-4 hours)

---

### **📋 Phase 5: Publisher Broadcast Features** *(Target: Week of Nov 18)*

**Note:** Simple Laravel CRUD on top of proven MCP infrastructure. The hard work (MCPs) is done.

**Goals:**
- Publisher authentication and registration
- Public/private publisher lists
- Broadcast notifications to subscribers (reuses MCP infrastructure)
- Subscription management

**Tasks:**
1. **Publisher Authentication:**
   - Publisher registration/login flow (not anonymous like subscribers)
   - Publisher profile management
   - Store publisher messages in database
   
2. **PublisherList Features:**
   - List creation and management UI
   - Public list discovery
   - Private list invitations
   
3. **Broadcast Logic:**
   - Broadcast notification use cases (reuses SendDirectMessageUseCase pattern)
   - Subscriber preference management
   - Notification scheduling

**Success Metrics:**
- Publishers can create and manage lists
- Subscribers can discover and subscribe to public lists
- Private lists require approval
- Broadcast notifications delivered via proven channel system

**Status:** Not Started 📋

---

### **📋 Phase 6: Testing & Quality** *(Target: Week of Nov 25)*

**Goals:**
- Comprehensive test coverage
- Performance optimization
- Security audit

**Tasks:**
1. Domain layer unit tests (100% coverage)
2. Application layer use case tests
3. Infrastructure integration tests
4. Performance benchmarks
5. Security review

**Success Metrics:**
- >90% code coverage
- All critical paths tested
- Performance targets met

**Status:** Not Started 📋

---

### **📋 Phase 7: Production Deployment** *(Target: Week of Dec 2)*

**Goals:**
- Deploy to production
- Monitoring and logging
- Documentation complete

**Tasks:**
1. Production environment setup
2. CI/CD pipeline
3. Monitoring dashboards
4. User documentation
5. API documentation

**Success Metrics:**
- Production deployment successful
- Monitoring active
- Documentation complete

**Status:** Not Started 📋

---

## 🔮 **Future Phases (Beyond MVP)**

### **Phase 7: Microservices Evolution**

Extract channels into separate services:
```
Core Service (Laravel) ←→ Alexa Service (AWS Lambda - Python)
                       ←→ Slack Service (Google Cloud - Go)
                       ←→ Discord Service (Kubernetes - Node.js)
```

**Key Insight (Validated Oct 17):** Current database schema requires **zero breaking changes** for MCP transition.

### **Phase 8: Advanced Features**

- Real-time notifications
- Notification scheduling
- Analytics dashboard
- Publisher insights
- Subscriber preferences UI

### **Phase 9: Enterprise Features**

- Multi-tenant support
- SSO integration
- Advanced permissions
- Audit logging
- SLA monitoring

---

## 📊 **Progress Tracking**

| Phase                  | Status         | Start Date   | End Date    | Duration        |
|------------------------|----------------|--------------|-------------|-----------------|
| Phase 0: Setup         | ✅ Complete    | Oct 7, 2025  | Oct 7, 2025 | 2 hours         |
| Phase 1: Foundation    | 🚧 In Progress | Oct 17, 2025 | Oct 24, 2025 (est.) | ~1 week (est.)  |
| Phase 2: Alexa         | 📋 Planned     | TBD          | TBD         | ~2 weeks        |
| Phase 3: Multi-Channel | 📋 Planned     | TBD          | TBD         | ~2 weeks        |
| Phase 4: Features      | 📋 Planned     | TBD          | TBD         | ~1 week         |
| Phase 5: Testing       | 📋 Planned     | TBD          | TBD         | ~1 week         |
| Phase 6: Production    | 📋 Planned     | TBD          | TBD         | ~1 week         |

---

## 🎯 **Current Sprint**

**Sprint:** Phase 1 - Registration Foundation → Hexagonal Structure  
**Duration:** Oct 17-24, 2025  
**Goal:** Complete hexagonal architecture foundation

**This Week's Focus:**
1. ✅ Registration foundation (complete Oct 17)
2. 📋 Create `src/ObserversHex/` directory structure
3. 📋 Implement first domain entity (Subscriber)
4. 📋 Create first use case (ActivateChannel)
5. 📋 Set up domain testing

**Completed This Sprint (Oct 17):**
- Observer chain (UserObserver, SubscriberObserver, ServiceChannelObserver)
- Database schema (service_channels, subscriber_service_channels)
- Model boot functions (Subscriber, SubscriberServiceChannel)
- Seeders validated (correct execution order)
- Comprehensive documentation (ARCHITECTURE_REGISTRATION_FLOW.md, PHASE_1_REGISTRATION_FOUNDATION.md)

---

## 📝 **Key Decisions Log**

| Date         | Decision                                 | Rationale                                           |
|--------------|------------------------------------------|-----------------------------------------------------|
| Oct 7, 2025  | Use hexagonal architecture               | Enable future microservices, framework independence |
| Oct 7, 2025  | Username-based integration               | Simpler than OAuth, better privacy                  |
| Oct 7, 2025  | Alexa as first channel                   | Forces true hexagonal thinking                      |
| Oct 7, 2025  | PublisherList as core entity             | Users subscribe to topics, not publishers           |
| Oct 7, 2025  | mcpTaiga for project management          | Automated Taiga population from git/docs            |
| Oct 17, 2025 | SubscriberServiceChannel as full model   | Supports rich behavior, not just pivot table        |
| Oct 17, 2025 | Boot functions + DB defaults             | Layered defense, explicit business rules            |
| Oct 17, 2025 | Observer chain for data consistency      | Infrastructure automation, not domain logic         |
| Oct 17, 2025 | Subscriber-centric design                | Cleaner domain separation (auth vs notifications)   |
| Oct 17, 2025 | ServiceChannel as separate entity        | MCP-ready, allows channel metadata                  |

---

## 🚀 **Next Actions**

**Immediate (This Week - Oct 18-24):**
1. Create hexagonal architecture directory structure
2. Update composer.json autoload configuration
3. Implement first domain entity (Subscriber value object)
4. Create first use case (ActivateChannelUseCase)
5. Write first domain test

**Short-term (Next 2 Weeks):**
1. Complete Phase 1 foundation
2. Begin Alexa adapter development
3. Set up testing framework

**Long-term (Next Month):**
1. Complete Alexa integration
2. Add 2-3 additional channels
3. Production deployment planning

---

## 📚 **Resources**

- **Taiga Board**: https://tree.taiga.io/project/frankpulido-notifier/
- **Architecture Doc**: README_dev.md
- **AI Context**: WARP.md
- **Notion Planning**: https://nine-yogurt-e7b.notion.site/v2-Project-Notifier-Publisher-Subscriber-27a4893773ea800eabb0f255c5b3286c
- **Registration Rationale**: ARCHITECTURE_REGISTRATION_FLOW.md
- **Phase 1 Summary**: PHASE_1_REGISTRATION_FOUNDATION.md
- **Evolution Analysis**: PROJECT_EVOLUTION_ANALYSIS_UPDATED.md

---

## 🎊 **Milestones**

- ✅ **Project Kickoff** - October 7, 2025
- ✅ **Phase 0 Complete** - October 7, 2025
- ✅ **Registration Foundation Complete** - October 17, 2025
- ✅ **Production Deployment** - October 20, 2025 (Railway)
- 📋 **Phase 1 Complete** - Target: October 24, 2025
- 📋 **First Notification Sent** - TBD
- 📋 **Multi-Channel Working** - TBD

---

**Remember:** This is evolutionary architecture. Let the design emerge from real requirements rather than imposing theoretical patterns.

**Status:** Living Document - Updated at phase boundaries  
**Owner:** Frank Pulido  
**Contributors:** AI Assistant (Warp - Claude 4.5 Sonnet)  
**Last Major Update:** October 17, 2025 - Registration Foundation Complete
