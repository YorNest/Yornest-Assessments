# Intentional Bugs Reference (INTERNAL ONLY)

**⚠️ DO NOT SHARE THIS FILE WITH CANDIDATES**

This document lists the intentional bugs placed in the iOS assessment for candidates to find and fix.

---

## Bug #1: Delete Message Index Issue

**Location:** `MessagesPresenter.swift` - `deleteMessage(at:)` method

**Description:** The method captures the index and uses it to remove the message from the array after the async deletion call. However, if the user rapidly deletes multiple messages, the indices could become stale.

**The Bug:**
```swift
let messageId = currentMessages[index].id
try await messagesService.deleteMessage(messageId: messageId)
currentMessages.remove(at: index)  // BUG: index could be stale
```

**Expected Fix:**
```swift
let messageId = currentMessages[index].id
try await messagesService.deleteMessage(messageId: messageId)
// Remove by ID, not by index
currentMessages.removeAll { $0.id == messageId }
```

---

## Bug #2: Thread Safety Issue

**Location:** `MessagesPresenter.swift` - `messageCount` property

**Description:** The `messageCount` property accesses `currentMessages` without proper thread synchronization, which could lead to data races.

**The Bug:**
```swift
var messageCount: Int {
    return currentMessages.count  // Not thread-safe
}
```

**Expected Fix:**
```swift
@MainActor
var messageCount: Int {
    return currentMessages.count
}
// OR use a lock/actor isolation
```

---

## Bug #3: Avatar Color Consistency

**Location:** `MessageCell.swift` - `configure(with:)` method

**Description:** Using `hashValue` for color selection is problematic because Swift's `hashValue` is not guaranteed to be stable across app launches. The same sender could get different colors on different runs.

**The Bug:**
```swift
let colorIndex = abs(message.senderId.hashValue) % colors.count
avatarView.backgroundColor = colors[colorIndex]
```

**Expected Fix:**
```swift
// Use a deterministic hash function
let hash = message.senderId.utf8.reduce(0) { $0 &+ Int($1) }
let colorIndex = abs(hash) % colors.count
avatarView.backgroundColor = colors[colorIndex]
```

---

## Incomplete Test

**Location:** `MessagesStateTests.swift` - `testRefreshingState_ShouldMaintainExistingMessages()`

**Description:** This test is marked with `XCTFail` and candidates need to implement it.

**Expected Implementation:**
```swift
func testRefreshingState_ShouldMaintainExistingMessages() {
    // Given
    let messages = TestUtils.createSampleMessages(count: 3)
    let state = MessagesState.refreshing(messages: messages)
    
    // Then
    if case .refreshing(let existingMessages) = state {
        XCTAssertEqual(existingMessages.count, 3)
        XCTAssertEqual(existingMessages, messages)
    } else {
        XCTFail("Expected refreshing state with messages")
    }
}
```

---

## Assessment Criteria

When evaluating candidates, look for:

1. **Bug Discovery** - Did they identify the bugs?
2. **Understanding** - Do they understand WHY these are bugs?
3. **Fix Quality** - Are the fixes robust and follow best practices?
4. **Testing** - Did they add tests for the fixes?
5. **Communication** - Did they document their findings clearly?

