# 📨 Feature: Subscriber-to-Subscriber Direct Messaging

**Status:** Implementation Phase  
**Created:** October 20, 2025  
**Last Updated:** October 21, 2025  
**Priority:** Phase 2 Feature  
**Implementation Status:** AuthorizedSender model complete ✅

---

## 🎯 Feature Overview

Enable subscribers to send direct messages to each other through the receivers' preferred notification channels (Alexa, Telegram, Discord, Slack) with a **privacy-first, receiver-controlled authorization model**.

### **Core Principles**

1. **Receiver Authorization** - Recipients explicitly authorize who can message them
2. **Channel Privacy** - Senders never see recipient's channel choice
3. **No User Discovery** - No user search, no user lists, usernames must be known externally
4. **Zero Message Storage** - Message content never persisted, only delivery metadata
5. **Rate Limiting** - Prevent spam with reasonable limits (20 messages/hour per sender)

---

## 🔐 Authorization Model

### **How It Works**

```
┌─────────────────────────────────────────────────────────┐
│  ALICE wants to message BOB                             │
│                                                          │
│  ❌ By default: Alice CANNOT message Bob                │
│  ✅ Bob must authorize Alice first                      │
│  ✅ Bob chooses which channel to receive on (Telegram)  │
│  🔒 Alice never sees Bob's channel choice               │
│                                                          │
│  When Alice sends:                                      │
│  1. System checks: Is Alice in Bob's authorized list?   │
│  2. If YES: Send via Bob's chosen channel (Telegram)    │
│  3. If NO: Reject with "Not authorized"                 │
└─────────────────────────────────────────────────────────┘
```

### **Key Flows**

#### **1. Bob Authorizes Alice**
- Bob logs into platform
- Goes to "My Authorized Senders"
- Clicks "[+ Authorize New Sender]"
- Enters username: `alice`
- Selects preferred channel: `Telegram`
- System creates authorization record

#### **2. Alice Sends Message to Bob**
- Alice uses platform API/UI to send message
- System validates:
  - ✅ Is Alice in Bob's `authorized_senders`?
  - ✅ Does Bob have active Telegram channel?
  - ✅ Has Alice stayed under rate limit (20/hour)?
- If all pass: Message delivered via Bob's Telegram
- Alice sees: ✓ (delivered) or ✗ (failed)
- Alice does NOT see: channel used, failure reason

#### **3. Bob Revokes Alice**
- Bob goes to "My Authorized Senders"
- Finds `alice - I receive via Telegram`
- Clicks `[Remove]`
- Authorization deleted
- Future messages from Alice rejected

---

## 🏗️ Three-Model Architecture

The direct messaging system uses **three distinct models** that work together:

### **1. AuthorizedSender (SQL - Persistent)**
**Purpose:** Authorization and channel configuration  
**Stored:** MySQL database  
**Lifespan:** Permanent (until revoked)

```php
class AuthorizedSender extends Model {
    // Stores: receiver_id, sender_id, subscriber_service_channel_id
    // Represents: "Bob authorizes Alice to send to him via his Telegram"
}
```

**Relationships:**
- `receiver()` → Subscriber who grants authorization
- `sender()` → Subscriber being authorized
- `subscriberServiceChannel()` → Receiver's chosen channel for THIS sender

**Key Method:**
```php
$bob->hasAuthorized($alice); // Check if Bob authorized Alice
```

---

### **2. DirectMessage (DTO/Value Object - Transient)**
**Purpose:** Message content for delivery  
**Stored:** Redis queue (temporary)  
**Lifespan:** Ephemeral (discarded after delivery)

```php
class DirectMessage {
    public string $title;
    public string $message;
    public int $senderId;
    public int $receiverId;
    // Lives in Redis, picked up by MCP for delivery
    // NEVER stored in SQL
}
```

**Flow:**
1. User sends message → `DirectMessage` object created
2. Message pushed to Redis queue
3. MCP worker picks it up → delivers via channel
4. Message content discarded

---

### **3. DirectMessageLog (SQL - Persistent)**
**Purpose:** Delivery metadata for rate limiting & history  
**Stored:** MySQL database  
**Lifespan:** Permanent (audit trail)

```php
class DirectMessageLog extends Model {
    // Stores: sender_id, receiver_id, sent_at, status
    // NO title, NO message, NO channel_id
    // Only metadata: who, when, delivered/failed
}
```

**Privacy Design:**
- ❌ No message content (ephemeral in Redis)
- ❌ No channel_id (receiver looks it up via `AuthorizedSender`)
- ✅ Only metadata for rate limiting (20/hour check)
- ✅ Delivery status for user history (✓/✗)

---

## 🔄 How They Work Together

```
┌─────────────────────────────────────────────────────────────┐
│  ALICE sends message to BOB                                 │
│                                                              │
│  Step 1: Check Authorization                                │
│  ────────────────────────────────────────────────────────  │
│  Query: AuthorizedSender                                    │
│  → Does Bob have Alice in authorized_senders?              │
│  → Get Bob's subscriber_service_channel_id for Alice       │
│  ✅ YES: Continue    ❌ NO: Reject "Not authorized"         │
│                                                              │
│  Step 2: Check Rate Limit                                   │
│  ────────────────────────────────────────────────────────  │
│  Query: DirectMessageLog                                    │
│  → Count Alice's messages to Bob in last hour              │
│  ✅ < 20: Continue   ❌ ≥ 20: Reject "Rate limit exceeded"  │
│                                                              │
│  Step 3: Queue Message                                      │
│  ────────────────────────────────────────────────────────  │
│  Create: DirectMessage object                               │
│  → Push to Redis queue with title + message + IDs          │
│  → MCP worker picks up → delivers via Bob's Telegram       │
│  → Message content discarded after delivery                 │
│                                                              │
│  Step 4: Log Metadata                                       │
│  ────────────────────────────────────────────────────────  │
│  Create: DirectMessageLog entry                             │
│  → sender_id: Alice, receiver_id: Bob                      │
│  → sent_at: now, status: delivered/failed                  │
│  → NO title, NO message, NO channel                         │
│  → Used for rate limiting next message                      │
└─────────────────────────────────────────────────────────────┘
```

**Key Insight:** Channel lookup is performed dynamically:
```php
// Receiver can always see which channel was used:
$authorization = AuthorizedSender::where('receiver_id', $bob->id)
                                 ->where('sender_id', $alice->id)
                                 ->first();
$channel = $authorization->subscriberServiceChannel; // Bob's Telegram

// Sender NEVER sees the channel (not stored in DirectMessageLog)
```

---

## 🗄️ Database Schema

### **New Table: `authorized_senders`**

```sql
CREATE TABLE authorized_senders (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    
    -- Receiver (controls this authorization)
    receiver_id BIGINT UNSIGNED NOT NULL,
    
    -- Authorized sender
    sender_id BIGINT UNSIGNED NOT NULL,
    
    -- Receiver's preferred channel for THIS sender
    channel_id BIGINT UNSIGNED NOT NULL,
    
    -- Timestamps
    authorized_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Constraints
    UNIQUE KEY unique_receiver_sender (receiver_id, sender_id),
    
    FOREIGN KEY (receiver_id) REFERENCES subscribers(id) ON DELETE CASCADE,
    FOREIGN KEY (sender_id) REFERENCES subscribers(id) ON DELETE CASCADE,
    FOREIGN KEY (channel_id) REFERENCES subscriber_service_channels(id) ON DELETE CASCADE,
    
    -- Indexes
    INDEX idx_receiver (receiver_id),
    INDEX idx_sender (sender_id)
);
```

**Design Notes:**
- `receiver_id` - The subscriber who grants authorization
- `sender_id` - The subscriber being authorized to send
- `channel_id` - References receiver's active channel (ONE per authorization)
- Unique constraint prevents duplicate authorizations
- Cascading deletes maintain referential integrity

### **New Table: `direct_message_log`**

```sql
CREATE TABLE direct_message_log (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    
    -- Who and when
    sender_id BIGINT UNSIGNED NOT NULL,
    receiver_id BIGINT UNSIGNED NOT NULL,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Delivery status (for rate limiting & history)
    status ENUM('delivered', 'failed') NOT NULL,
    
    -- Constraints
    FOREIGN KEY (sender_id) REFERENCES subscribers(id) ON DELETE CASCADE,
    FOREIGN KEY (receiver_id) REFERENCES subscribers(id) ON DELETE CASCADE,
    
    -- Indexes
    INDEX idx_sender_time (sender_id, sent_at),
    INDEX idx_receiver_time (receiver_id, sent_at)
);
```

**Privacy Design:**
- ❌ No `message_content` - never stored (ephemeral in Redis)
- ❌ No `title` - never stored (ephemeral in Redis)
- ❌ No `channel_id` - not needed (lookup via `AuthorizedSender`)
- ❌ No `failure_reason` - sender doesn't see details
- ✅ Only metadata for rate limiting and delivery tracking
- ✅ Simple `delivered`/`failed` status

**Why no channel_id?**
Receiver can dynamically query their chosen channel:
```php
$authorization = $receiver->authorizedSenders()
                          ->where('sender_id', $sender->id)
                          ->first();
$channel = $authorization->subscriberServiceChannel;
```

---

## 🎨 Platform UI

### **Bob's Dashboard**

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
MY AUTHORIZED SENDERS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

alice - I receive via Telegram
[Change Channel] [Remove]

charlie - I receive via Alexa
[Change Channel] [Remove]

[+ Authorize New Sender]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
I CAN SEND TO
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

- alice
- david
- emma

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
MESSAGE HISTORY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Sent:
- To alice: Today 3:45pm ✓
- To david: Today 2:30pm ✗
- To emma: Yesterday 11:20am ✓

Received:
- From alice: Today 3:40pm via Telegram
- From charlie: Today 1:15pm via Alexa
```

**Privacy Notes:**
- Bob sees HIS chosen channels (Telegram, Alexa)
- Bob does NOT see Alice's channel choice
- Sent messages: simple ✓/✗ (no details)
- Received messages: show which of Bob's channels was used

---

## 🔒 Privacy & Security

### **What Senders DON'T See**
- ❌ Recipient's channel choice
- ❌ Failure reasons (channel offline, rate limit hit, etc.)
- ❌ Whether recipient has ANY channels active
- ❌ Message content after send (never stored)

### **What Receivers Control**
- ✅ Who can message them (authorization whitelist)
- ✅ Which channel to use per sender
- ✅ Ability to revoke at any time
- ✅ View received message history with channel info

### **Rate Limiting**
- **20 messages per hour per sender**
- Prevents spam while allowing reasonable communication
- Enforced at application layer before delivery attempt
- Counter resets hourly per sender

### **No User Discovery**
- No user search functionality
- No user directory/list
- Usernames must be exchanged outside platform
- Authorization requires exact username match

---

## 🏗️ Architecture (Hexagonal)

### **Domain Layer**

```php
// Domain/DirectMessaging/Entities/Authorization.php
class Authorization {
    private SubscriberId $receiverId;
    private SubscriberId $senderId;
    private ServiceChannelId $channelId;
    private DateTimeImmutable $authorizedAt;
    
    public function isAuthorized(SubscriberId $senderId): bool;
    public function changeChannel(ServiceChannelId $newChannelId): void;
}

// Domain/DirectMessaging/ValueObjects/DirectMessage.php
// This is a DTO/Value Object, NOT a database model
// Lives in Redis queue temporarily, discarded after delivery
class DirectMessage {
    private string $title;
    private string $message;
    private SubscriberId $senderId;
    private SubscriberId $receiverId;
    private DateTimeImmutable $createdAt;
    
    // Serialized to Redis → Picked up by MCP → Delivered → Discarded
    // NEVER persisted to SQL
}

// Domain/DirectMessaging/Services/RateLimitService.php
class RateLimitService {
    private const HOURLY_LIMIT = 20;
    
    public function canSend(SubscriberId $senderId, SubscriberId $receiverId): bool;
    public function recordAttempt(SubscriberId $senderId, SubscriberId $receiverId): void;
}

// Domain/DirectMessaging/Services/AuthorizationService.php
class AuthorizationService {
    public function authorize(
        SubscriberId $receiverId, 
        SubscriberId $senderId, 
        ServiceChannelId $channelId
    ): Authorization;
    
    public function revoke(SubscriberId $receiverId, SubscriberId $senderId): void;
    public function getAuthorization(SubscriberId $receiverId, SubscriberId $senderId): ?Authorization;
}
```

### **Application Layer**

```php
// Application/UseCases/DirectMessaging/SendDirectMessage.php
class SendDirectMessageUseCase {
    public function execute(SendDirectMessageCommand $command): SendDirectMessageResult {
        // 1. Check authorization
        // 2. Check rate limit
        // 3. Validate channel is active
        // 4. Dispatch to channel (via NotificationDispatcher)
        // 5. Log delivery attempt (no content)
        // 6. Return simple success/failure
    }
}

// Application/UseCases/DirectMessaging/AuthorizeSender.php
class AuthorizeSenderUseCase {
    public function execute(AuthorizeSenderCommand $command): void {
        // 1. Validate receiver exists
        // 2. Validate sender exists
        // 3. Validate channel belongs to receiver and is active
        // 4. Create authorization record
    }
}

// Application/UseCases/DirectMessaging/RevokeSender.php
class RevokeSenderUseCase {
    public function execute(RevokeSenderCommand $command): void {
        // 1. Find authorization
        // 2. Delete authorization
    }
}

// Application/UseCases/DirectMessaging/GetAuthorizedSenders.php
class GetAuthorizedSendersUseCase {
    public function execute(GetAuthorizedSendersQuery $query): AuthorizedSendersDTO {
        // Return list of authorized senders with chosen channels
    }
}

// Application/UseCases/DirectMessaging/GetReceiversICanMessageUseCase.php
class GetReceiversICanMessageUseCase {
    public function execute(GetReceiversQuery $query): ReceiversListDTO {
        // Return list of subscribers who authorized this sender
    }
}
```

### **Infrastructure Layer**

```php
// Infrastructure/Laravel/Repositories/AuthorizationRepository.php
class LaravelAuthorizationRepository implements AuthorizationRepositoryInterface {
    // CRUD operations on authorized_senders table
}

// Infrastructure/Laravel/Repositories/DirectMessageLogRepository.php
class LaravelDirectMessageLogRepository implements DirectMessageLogRepositoryInterface {
    // Insert delivery logs (metadata only, no content)
}

// Infrastructure/Laravel/Controllers/DirectMessageController.php
class DirectMessageController {
    public function send(SendMessageRequest $request);
    public function getAuthorizedSenders();
    public function authorizeSender(AuthorizeRequest $request);
    public function revokeSender($senderId);
    public function getReceiversICanMessage();
    public function getMessageHistory();
}
```

---

## 🚀 Implementation Phases

### **Phase 2.1: Authorization Foundation**
**Estimated:** 4-6 hours

- [ ] Create migrations for `authorized_senders` and `direct_message_log`
- [ ] Build Domain entities (Authorization, DirectMessage value objects)
- [ ] Implement AuthorizationService (authorize/revoke/check)
- [ ] Build Authorization repository
- [ ] Write domain tests

### **Phase 2.2: Rate Limiting**
**Estimated:** 3-4 hours

- [ ] Implement RateLimitService with 20/hour limit
- [ ] Add rate limit checks to domain logic
- [ ] Create direct_message_log repository
- [ ] Add time-window query methods
- [ ] Write rate limit tests

### **Phase 2.3: Message Sending Use Cases**
**Estimated:** 4-5 hours

- [ ] Build SendDirectMessageUseCase
- [ ] Integrate with existing NotificationDispatcher
- [ ] Add authorization + rate limit validation
- [ ] Implement delivery logging (metadata only)
- [ ] Write use case tests

### **Phase 2.4: Authorization Use Cases**
**Estimated:** 3-4 hours

- [ ] Build AuthorizeSenderUseCase
- [ ] Build RevokeSenderUseCase
- [ ] Build GetAuthorizedSendersUseCase
- [ ] Build GetReceiversICanMessageUseCase
- [ ] Write use case tests

### **Phase 2.5: API & UI**
**Estimated:** 6-8 hours

- [ ] Create Laravel API routes and controllers
- [ ] Build React UI components (authorization management)
- [ ] Implement message sending interface
- [ ] Add message history views
- [ ] Integration tests

### **Phase 2.6: Testing & Documentation**
**Estimated:** 3-4 hours

- [ ] End-to-end testing scenarios
- [ ] Performance testing (rate limits, concurrent sends)
- [ ] API documentation
- [ ] User guide
- [ ] Update project README

**Total Estimated Time:** 23-31 hours

---

## 📊 API Specification

### **POST /api/direct-messages/send**

**Request:**
```json
{
  "receiver_username": "bob",
  "message": "Hey Bob, quick question about the project..."
}
```

**Response (Success):**
```json
{
  "success": true,
  "sent_at": "2025-10-20T16:30:00Z"
}
```

**Response (Failure):**
```json
{
  "success": false,
  "error": "not_authorized"
}
```

**Error Codes:**
- `not_authorized` - Receiver hasn't authorized you
- `rate_limit_exceeded` - You've hit 20 messages/hour limit
- `receiver_not_found` - Username doesn't exist
- `delivery_failed` - Generic failure (no details)

---

### **POST /api/direct-messages/authorize**

**Request:**
```json
{
  "sender_username": "alice",
  "channel_id": 42
}
```

**Response:**
```json
{
  "success": true,
  "authorization": {
    "sender_username": "alice",
    "channel": "Telegram",
    "authorized_at": "2025-10-20T16:30:00Z"
  }
}
```

---

### **DELETE /api/direct-messages/authorize/{senderId}**

**Response:**
```json
{
  "success": true
}
```

---

### **GET /api/direct-messages/authorized-senders**

**Response:**
```json
{
  "authorized_senders": [
    {
      "sender_id": 123,
      "sender_username": "alice",
      "channel": "Telegram",
      "authorized_at": "2025-10-20T16:30:00Z"
    },
    {
      "sender_id": 456,
      "sender_username": "charlie",
      "channel": "Alexa",
      "authorized_at": "2025-10-19T10:15:00Z"
    }
  ]
}
```

---

### **GET /api/direct-messages/can-send-to**

**Response:**
```json
{
  "receivers": [
    {
      "receiver_id": 789,
      "receiver_username": "alice"
    },
    {
      "receiver_id": 101,
      "receiver_username": "david"
    }
  ]
}
```

---

### **GET /api/direct-messages/history**

**Query Params:**
- `type`: `sent` | `received` | `all` (default: `all`)
- `limit`: number (default: 50)
- `offset`: number (default: 0)

**Response:**
```json
{
  "sent": [
    {
      "receiver_username": "alice",
      "sent_at": "2025-10-20T15:45:00Z",
      "status": "delivered"
    },
    {
      "receiver_username": "david",
      "sent_at": "2025-10-20T14:30:00Z",
      "status": "failed"
    }
  ],
  "received": [
    {
      "sender_username": "alice",
      "received_at": "2025-10-20T15:40:00Z",
      "channel": "Telegram"
    }
  ]
}
```

---

## 🧪 Testing Scenarios

### **Authorization Tests**
1. ✅ Receiver can authorize sender
2. ✅ Receiver can revoke authorization
3. ✅ Cannot create duplicate authorizations
4. ✅ Cascading delete when subscriber deleted
5. ✅ Channel must belong to receiver

### **Rate Limiting Tests**
1. ✅ Allow 20 messages in one hour
2. ✅ Block 21st message in same hour
3. ✅ Reset counter after hour window
4. ✅ Independent counters per sender-receiver pair

### **Message Sending Tests**
1. ✅ Authorized sender can send
2. ✅ Unauthorized sender blocked
3. ✅ Message delivered to correct channel
4. ✅ Sender sees only success/failure
5. ✅ Receiver sees channel used
6. ✅ No message content stored

### **Privacy Tests**
1. ✅ Sender cannot query receiver's channels
2. ✅ No user discovery endpoints
3. ✅ Authorization requires exact username
4. ✅ No failure reason exposure

---

## 📝 Open Questions & Future Enhancements

### **Current Scope (Phase 2)**
- [x] One-way authorization model
- [x] Single channel per sender-receiver pair
- [x] Basic rate limiting (20/hour)
- [x] Simple delivery status (delivered/failed)

### **Future Considerations (Phase 3+)**
- [ ] **Message Templates** - Pre-defined message formats for common use cases
- [ ] **Scheduled Messages** - Send at specific time
- [ ] **Message Expiry** - TTL for urgent messages
- [ ] **Read Receipts** - Optional, receiver-controlled
- [ ] **Mutual Authorization Shortcuts** - "Allow messages from people I'm authorized to message"
- [ ] **Emergency Override** - Platform admin can disable messaging for abuse
- [ ] **Analytics Dashboard** - Messaging patterns, popular channels, etc.

---

## 🔗 Related Documentation

- `PROJECT_ROADMAP.md` - Overall project phases
- `ARCHITECTURE.md` - Hexagonal architecture overview
- `STRATEGY_MCP.md` - MCP channel integration
- `docs/SCHEMA_SUBSCRIBER_SERVICE_CHANNELS.md` - Channel management
- `docs/PROJECT_EVOLUTION_ANALYSIS.md` - Schema evolution history

---

**Document Version:** 1.0  
**Next Review:** After Phase 2.1 implementation  
**Maintained By:** Frank Pulido + AI Assistant
