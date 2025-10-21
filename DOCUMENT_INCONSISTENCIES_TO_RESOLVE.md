# 📋 Documentation Inconsistencies to Resolve

**Created:** October 20, 2025  
**Purpose:** Track all documentation inconsistencies, conflicts, and pending design decisions  
**Status:** Active tracking document - update as issues are resolved

---

## 🔴 CRITICAL ISSUES (Must Fix Immediately)

### **1. Schema Name Inconsistency ❌**

**Status:** Critical - Wrong table name in 3+ documents  
**Priority:** P0  
**Effort:** 30 minutes

**Problem:**
- **README_dev.md (line 79):** References `user_service_channels`
- **PROJECT_EVOLUTION_ANALYSIS.md (line 79):** References `user_service_channels`
- **docs/STRATEGY_MCP.md:** References `user_service_channels`
- **ACTUALLY BUILT (Oct 17):** `subscriber_service_channels` table

**Impact:** 
- Confuses future AI sessions
- Developers following old docs will look for wrong table
- Migration scripts in docs won't work

**Resolution Required:**
1. Update README_dev.md: Replace all `user_service_channels` → `subscriber_service_channels`
2. Update PROJECT_EVOLUTION_ANALYSIS.md: Same replacement
3. Update docs/STRATEGY_MCP.md: Same replacement
4. Add note explaining why schema is subscriber-centric, not user-centric

**Rationale to Document:**
> Changed from user-centric to subscriber-centric design during Oct 17 implementation because:
> - Better domain separation (User = auth, Subscriber = notification profile)
> - Aligns with existing Subscriber model architecture
> - Supports observer pattern for automatic consistency
> - Future-proof for MCP transition

**Assigned:** Pending  
**Due Date:** Before next development session

---

### **2. Laravel Version Error ❌**

**Status:** Critical - Factual error  
**Priority:** P0  
**Effort:** 5 minutes

**Problem:**
- **WARP_UPDATED.md (line 38):** Says "Laravel 11"
- **Reality:** Project uses Laravel 12

**Impact:**
- Technical inaccuracy in main context document
- Could lead to wrong dependency assumptions

**Resolution Required:**
1. Update WARP_UPDATED.md line 38: "Laravel 11" → "Laravel 12"
2. Search all docs for "Laravel 11" and replace
3. Verify no Laravel 11-specific advice in docs

**Assigned:** Pending  
**Due Date:** Today (Oct 20)

---

### **3. Railway Deployment Status Outdated ❌**

**Status:** Critical - Deployment successful but not documented  
**Priority:** P0  
**Effort:** 15 minutes

**Problem:**
- **All docs:** Say "Railway Deployment: [To be configured]"
- **Reality (Oct 20):** 
  - Successfully deployed
  - Fixed faker seeding issue
  - Application is live

**Impact:**
- Docs don't reflect current production state
- No deployment URL documented
- Oct 20 deployment work not recorded

**Resolution Required:**
1. Get Railway production URL
2. Update WARP_UPDATED.md:
   ```markdown
   ## 🔗 **Important Links**
   - **Railway Deployment**: [URL]
   - **Deployment Status**: ✅ Live (deployed Oct 20, 2025)
   ```
3. Update PROJECT_ROADMAP_UPDATED.md with deployment milestone
4. Add Oct 20 session notes about faker fix

**Assigned:** Pending  
**Due Date:** Today (Oct 20)

---

### **4. Channel List Standardization ⚠️**

**Status:** High priority - Multiple inconsistent lists  
**Priority:** P1  
**Effort:** 20 minutes

**Problem:**
- **WARP.md (old):** Alexa, Slack, Discord, WhatsApp
- **WARP_UPDATED.md:** Alexa, Slack, Discord, Telegram, Home Assistant
- **README_dev.md (line 17):** Alexa, Slack, Discord, WhatsApp
- **SEEDED (Oct 17):** alexa, discord, home_assistant, slack, telegram

**Impact:**
- Confusing which channels are actually supported
- WhatsApp mentioned but not implemented

**Resolution Required:**
1. Standardize all docs to seeded list: **Alexa, Discord, Home Assistant, Slack, Telegram**
2. Update README_dev.md examples
3. Remove WhatsApp references (or mark as "future")
4. Document why these 5 channels chosen

**Assigned:** Pending  
**Due Date:** Before Phase 2 (Alexa implementation)

---

## 🟡 HIGH PRIORITY (Needs Design/Decision)

### **5. MCP Strategy - Vague and Uncommitted ⚠️**

**Status:** High priority - Strategic decision needed  
**Priority:** P1  
**Effort:** 2-4 hours (design session required)

**Problem:**
- **docs/STRATEGY_MCP.md:** Generic discussion, no concrete decisions
- **WARP_UPDATED.md:** References MCP as decided approach
- **PHASE_1_REGISTRATION_FOUNDATION.md:** Says schema is "MCP-ready"
- **Reality:** No MCP servers exist, no implementation timeline

**Unresolved Questions:**
1. **When?** Are MCPs in Phase 2, Phase 3, or later?
2. **Languages?** Python for Alexa? Node for Discord? Go for Slack?
3. **Communication?** Local stdio first, then network? Or network from start?
4. **Credentials?** Who manages service app credentials? MCP servers or core app?
5. **Deployment?** Separate Railway services? Docker containers? AWS Lambda?
6. **Development?** Can we test MCPs locally? Mock mode?
7. **Error handling?** Retry logic in core or MCP? Circuit breakers?
8. **Scope?** Are MCPs ONLY for sending notifications, or do they handle verification too?

**Impact:**
- Can't start Phase 2 (Alexa) without knowing if it's monolith or MCP
- Affects architecture decisions being made now
- Database schema decisions depend on MCP architecture

**Resolution Required:**
1. **Design session:** 2 hours to answer all questions above
2. **Create:** ARCHITECTURE_MCP_DETAILED.md with:
   - Concrete decisions for each question
   - Implementation timeline
   - Technical specifications per MCP
   - Communication protocol details
   - Deployment architecture diagram
3. **Update:** docs/STRATEGY_MCP.md with decisions or mark as "superseded by ARCHITECTURE_MCP_DETAILED.md"

**Assigned:** Pending  
**Due Date:** Before starting Alexa implementation  
**Blocker for:** Phase 2 work

---

### **6. Verification Flow - Designed but Not Implemented ⚠️**

**Status:** High priority - Core feature pending  
**Priority:** P1  
**Effort:** 4-6 hours (design + implementation)

**Problem:**
- **Database:** Has `verification_token`, `verified_at` columns (ready)
- **ARCHITECTURE_REGISTRATION_FLOW.md:** Shows mockup flow
- **README_dev.md:** References username verification
- **Reality:** NO implementation, NO detailed design

**Unresolved Questions:**
1. **Token generation:** UUID? Random string? Cryptographic hash? Length?
2. **Token lifetime:** 15 minutes? 1 hour? 24 hours? Configurable per channel?
3. **Delivery mechanism:** How does verification code reach user?
   - Alexa: Notification to device?
   - Slack: DM to user?
   - Discord: DM to user?
   - Telegram: Message?
   - Home Assistant: Push notification?
4. **User experience:** 
   - Web UI to input code?
   - Voice command for Alexa?
   - Slash command for Slack/Discord?
5. **Verification method:**
   - User inputs code in our app?
   - User responds to message in service?
   - Both options?
6. **Retry logic:** How many attempts? Resend functionality?
7. **Security:** Rate limiting? CSRF protection? Token reuse prevention?
8. **Programmatic vs manual:** Which channels support automatic verification vs require user action?

**Impact:**
- Users can't activate channels without verification
- Core user flow incomplete
- Can't test end-to-end notification delivery

**Resolution Required:**
1. **Design session:** 2 hours to design complete flow
2. **Create:** ARCHITECTURE_VERIFICATION_FLOW_DETAILED.md
3. **Implement:** 
   - Token generation service
   - Verification endpoint/command per channel
   - Token validation logic
   - Rate limiting
4. **Update:** ARCHITECTURE_REGISTRATION_FLOW.md with implementation details

**Assigned:** Pending  
**Due Date:** During Phase 2 (before public testing)  
**Blocker for:** User acceptance testing

---

### **7. Observer Pattern Philosophy - Contradictory Statements 🤔**

**Status:** Medium-high priority - Architectural philosophy  
**Priority:** P2  
**Effort:** 1 hour (discussion + documentation)

**Problem:**
Two different framings exist:

**Temporary scaffolding view:**
- **PHASE_1_REGISTRATION_FOUNDATION.md (line 218-246):**
  > "Observer Pattern as Infrastructure - Will be replaced by explicit domain services in hexagonal layer"
- **WARP_UPDATED.md (line 409-412):** Same statement

**Permanent infrastructure view:**
- **ARCHITECTURE_REGISTRATION_FLOW.md:**
  > "Observer-driven automation: Consistent state management"
- Treated as architectural feature, not temporary

**Questions:**
1. **When hexagonal layer is built, do observers stay or go?**
2. **If they go:** What replaces them? Explicit calls in use cases? Event bus?
3. **If they stay:** How do they coexist with domain events? Isn't this mixing concerns?
4. **Philosophy:** Are observers "infrastructure glue" or "domain automation"?

**Impact:**
- Affects how we build hexagonal layer
- Determines if observers are refactored or kept
- Influences domain event design

**Resolution Required:**
1. **Decision:** Keep observers as Laravel infrastructure OR migrate to domain events
2. **Document:** Add "Observer Pattern Philosophy" section to ARCHITECTURE_REGISTRATION_FLOW.md
3. **Plan:** If migrating, create migration strategy document
4. **Consistency:** Update all docs with unified philosophy

**Proposed Resolution:**
> **Observers are Laravel infrastructure automation, NOT domain logic.**
> - Current: Observers ensure data consistency in Laravel layer
> - Future: Domain services will have explicit logic (e.g., `UserRegistrationService`)
> - Transition: Observers remain during hexagonal migration for stability
> - Long-term: Domain events replace observers when hexagonal layer is primary

**Assigned:** Pending  
**Due Date:** Before creating hexagonal domain layer  
**Blocker for:** Phase 1b (Hexagonal Structure)

---

### **8. Phase Naming Confusion 🤔**

**Status:** Medium priority - Semantic clarity  
**Priority:** P2  
**Effort:** 30 minutes

**Problem:**
"Phase 1" means different things:

**Original plan (PROJECT_ROADMAP.md):**
- Phase 1 = Hexagonal directory structure + domain entities

**What actually happened:**
- Phase 1 = Registration Foundation (Oct 17)

**Current docs say:**
- "Phase 1 Partial Complete" (registration)
- "Phase 1 Continuation" (hexagonal next)

**Confusion:**
- Is registration foundation part of Phase 1 or separate?
- Should we have called it Phase 0.5?
- Does this invalidate the roadmap?

**Resolution Required:**
1. **Decision:** Rename phases to reflect reality OR keep original naming
2. **Option A - Rename:**
   - Phase 0: Setup ✅
   - Phase 1a: Registration Foundation ✅ (Oct 17)
   - Phase 1b: Hexagonal Structure 📋 (next)
   - Phase 2: Alexa Implementation 📋
3. **Option B - Keep original, add sub-phases:**
   - Phase 1: Foundation (combined)
     - ✅ Registration Foundation (Oct 17)
     - 📋 Hexagonal Structure (next)
   - Phase 2: Alexa
4. **Update:** PROJECT_ROADMAP_UPDATED.md with chosen structure

**Assigned:** Pending  
**Due Date:** During next roadmap update

---

## 🟢 MEDIUM PRIORITY (Can Defer)

### **9. PublisherList Feature - Undocumented Design ⚠️**

**Status:** Medium priority - Core feature lacks detail  
**Priority:** P3  
**Effort:** 3-4 hours (design document)

**Problem:**
- **Mentioned everywhere:** "PublisherList is genius", "users subscribe to lists"
- **Never detailed:** How does it actually work?

**Missing Design:**
1. **List creation:** API endpoint? UI? Validation?
2. **`is_private` flag:** What does private mean exactly?
   - Invite-only?
   - Approval required?
   - Hidden from search?
3. **Private list workflow:**
   - How do publishers invite subscribers?
   - Email invitation? In-app?
   - Can subscribers request access?
4. **Public list discovery:**
   - Search functionality?
   - Categories/tags?
   - Trending/popular?
5. **List management:**
   - Edit name/description?
   - Archive/delete?
   - Subscriber count limits?

**Impact:**
- Feature exists in database but no implementation plan
- Can't build publisher UI without design
- Subscriber onboarding incomplete

**Resolution Required:**
1. **Create:** FEATURE_PUBLISHER_LISTS.md
   - Complete feature specification
   - User stories for publishers and subscribers
   - API endpoints
   - Database queries
   - UI mockups/wireframes
2. **Add to roadmap:** Which phase implements this?

**Assigned:** Pending  
**Due Date:** Before Phase 3 or 4 (multi-channel testing)

---

### **10. Testing Strategy - Documented but Not Started ⚠️**

**Status:** Medium priority - Quality assurance  
**Priority:** P3  
**Effort:** Ongoing

**Problem:**
- **Every doc mentions testing:** Strategy outlined in multiple places
- **Reality:** No tests written, no framework configured

**Questions:**
1. **When to start testing?**
   - Now (TDD approach)?
   - After hexagonal layer (test domain first)?
   - Before Alexa (integration tests)?
2. **What to test first?**
   - Observer chain?
   - Model relationships?
   - Use cases (when they exist)?
3. **Testing framework:**
   - PHPUnit (available)?
   - Pest (alternative)?
   - Add testing dependencies?

**Resolution Required:**
1. **Decision:** When to start writing tests
2. **Plan:** Testing roadmap per phase
3. **Setup:** Configure testing framework
4. **Start:** Write first test (observer chain?)

**Assigned:** Pending  
**Due Date:** Discussed during Phase planning

---

### **11. Docker Configuration Sync ⚠️**

**Status:** Low-medium priority - DevOps consistency  
**Priority:** P3  
**Effort:** 1 hour

**Problem:**
- **README_docker_stack.md:** Describes 5-service local docker-compose setup
- **Railway Production:** Only 3 services (observers-hexagonal, mysql, redis)
- **Question:** Are they in sync?

**Actual Configurations:**

**Local Development (docker-compose):**
- nginx (port 8988)
- mysql (port 3700 → 3306)
- php (php-fpm 8.2)
- laravel (utility container)
- react (Vite on port 8989)

**Railway Production:**
- observers-hexagonal (PHP-Laravel backend with built-in PHP server)
- mysql (Railway managed service)
- redis (Railway managed service)
- frontend (React app served via `serve -s dist` on port 5173)

**Key Differences:**
- **nginx:** NOT in production (PHP built-in server + Railway routing handles requests)
- **React deployment:** Separate Railway service (not served by Laravel)
- **Service count:** 5 in local dev vs 4 in production (nginx not needed)
- **Environment variables:** railway.toml vs docker-compose.yml
- **Frontend URL:** React connects to backend via VITE_API_URL

**Resolution Required:**
1. ✅ **Clarified:** React IS deployed as separate Railway service (confirmed in railway.toml)
2. **Document:** Why nginx not needed in production (PHP built-in server sufficient)
3. **Verify:** PHP version in Railway Dockerfile
4. **Update:** README_docker_stack.md with production vs development architecture comparison
5. **Decision:** Should local dev mirror production (remove nginx) or keep it?

**Assigned:** Pending  
**Due Date:** When local development resumes

**Notes (Oct 20, 2025):**
- Production uses PHP built-in server via `railway-entrypoint.sh`
- Railway handles SSL/routing (nginx not needed)
- Redis used for sessions, cache, queue
- MySQL in Railway managed service

---

## ⚪ LOW PRIORITY (Cleanup)

### **12. "Tomorrow" References - Dead Dates ❌**

**Status:** Low priority - Cosmetic  
**Priority:** P4  
**Effort:** 10 minutes

**Problem:**
- **WARP.md:** "Tomorrow - Oct 9" (12 days ago)
- **PROJECT_ROADMAP.md:** "[To be added tomorrow]" (13 days ago)

**Resolution Required:**
1. Search all `.md` files for "tomorrow", "oct 9", "oct 8"
2. Remove or replace with "next session" or actual dates
3. Update any "pending" links with actual URLs

**Assigned:** Pending  
**Due Date:** During next doc cleanup session

---

### **13. Notion URL Updates ⚠️**

**Status:** Low priority - Reference links  
**Priority:** P4  
**Effort:** 5 minutes

**Problem:**
- **WARP.md (line 313):** "Notion Planning: [To be added]"
- **PROJECT_ROADMAP.md (line 383):** "Notion Planning: [To be added tomorrow]"
- **WARP_UPDATED.md:** Has actual URL
- **PROJECT_ROADMAP_UPDATED.md:** Has actual URL

**Notion URL:**
```
https://nine-yogurt-e7b.notion.site/v2-Project-Notifier-Publisher-Subscriber-27a4893773ea800eabb0f255c5b3286c
```

**Resolution Required:**
1. Update old docs with Notion URL OR
2. Archive old docs and use only _UPDATED versions

**Assigned:** Pending  
**Due Date:** During doc consolidation

---

### **14. File Consolidation Strategy 📁**

**Status:** Low priority - Organization  
**Priority:** P4  
**Effort:** 30 minutes

**Problem:**
- Duplicate files: `WARP.md` vs `WARP_UPDATED.md` (3 pairs total)
- Unclear which is canonical
- Git history shows evolution but causes confusion

**Options:**
1. **Delete old versions** - Clean but loses history context
2. **Archive old versions** - Rename with date suffix for reference
3. **Keep both** - Document which is current in README.md

**Proposed Resolution:**
```bash
# Archive old versions with date
mv WARP.md WARP_2025-10-14_pre-implementation.md
mv PROJECT_ROADMAP.md PROJECT_ROADMAP_2025-10-07_initial.md
mv PROJECT_EVOLUTION_ANALYSIS.md PROJECT_EVOLUTION_ANALYSIS_2025-10-08_theoretical.md

# Rename _UPDATED to canonical
mv WARP_UPDATED.md WARP.md
mv PROJECT_ROADMAP_UPDATED.md PROJECT_ROADMAP.md
mv PROJECT_EVOLUTION_ANALYSIS_UPDATED.md PROJECT_EVOLUTION_ANALYSIS.md

# Create archive directory
mkdir -p docs/archive
mv *_2025-*.md docs/archive/
```

**Assigned:** Pending  
**Due Date:** After all doc updates complete

---

## 📊 Summary Statistics

**Total Issues:** 14  
**Critical (P0):** 3  
**High (P1):** 5  
**Medium (P2-P3):** 4  
**Low (P4):** 2

**Estimated Total Effort:** ~15-25 hours
- Quick fixes (P0): 1 hour
- Design sessions (P1): 8-12 hours
- Implementation (P1): 4-6 hours
- Documentation (P2-P4): 2-6 hours

---

## 🎯 Recommended Action Plan

### **This Session (Oct 20 - 30 min):**
1. ✅ Fix Laravel version (5 min)
2. ✅ Update Railway deployment status (15 min)
3. ✅ Add Oct 20 session notes (10 min)

### **Next Session (60 min):**
4. Fix schema name in all docs (30 min)
5. Standardize channel lists (20 min)
6. Clean up "tomorrow" references (10 min)

### **Design Sessions (schedule separately):**
7. MCP Strategy session (2 hours)
8. Verification Flow session (2 hours)
9. Observer Philosophy discussion (1 hour)

### **Long-term (ongoing):**
10. PublisherList feature design
11. Testing strategy implementation
12. Docker configuration sync
13. File consolidation

---

## 📝 Resolution Log

| Issue | Priority | Resolved Date | Resolved By | Notes |
|-------|----------|---------------|-------------|-------|
| - | - | - | - | - |

---

**Maintained by:** Frank Pulido + AI Assistant  
**Last Updated:** October 20, 2025  
**Next Review:** After completing P0 issues
