# Test 6: WebSocket & Real-time Features (30 minutes)

## Overview
This test focuses on implementing real-time features using WebSockets, including handling race conditions, connection management, and optimistic updates.

## Tasks

### 6.1 WebSocket Connection Management
**File**: `utils/websocket.ts` (create new)

**Requirements**:
- [ ] Implement WebSocket connection with auto-reconnection
- [ ] Handle connection states (connecting, connected, disconnected, error)
- [ ] Implement exponential backoff for reconnection attempts
- [ ] Add connection heartbeat/ping mechanism
- [ ] Handle browser visibility changes (pause/resume connections)

### 6.2 Real-time Post Updates
**File**: `store/realtime.ts` (create new)

**Current Issues to Fix**:
- [ ] Race condition: Multiple users liking the same post simultaneously
- [ ] Race condition: Post updates arriving out of order
- [ ] Stale data: Local state conflicts with server updates
- [ ] Memory leaks: Event listeners not properly cleaned up

**Requirements**:
- [ ] Implement real-time post likes with conflict resolution
- [ ] Handle concurrent post edits with last-writer-wins or operational transforms
- [ ] Implement optimistic updates with rollback on conflicts
- [ ] Add message queuing for offline scenarios
- [ ] Implement proper cleanup on component unmount

### 6.3 Real-time Comments System
**File**: `components/RealTimeComments.tsx` (create new)

**Requirements**:
- [ ] Display comments in real-time as they're added
- [ ] Handle typing indicators for active users
- [ ] Implement comment ordering with race condition handling
- [ ] Add user presence indicators (who's online)
- [ ] Handle rapid comment submissions (debouncing/throttling)

### 6.4 Connection Status UI
**File**: `components/ConnectionStatus.tsx` (create new)

**Requirements**:
- [ ] Show connection status to users (connected/disconnected/reconnecting)
- [ ] Display offline mode indicator
- [ ] Show sync status for pending operations
- [ ] Add manual reconnect button
- [ ] Handle graceful degradation when WebSocket unavailable

## Race Conditions to Handle

### 1. Concurrent Likes
**Scenario**: Two users like the same post at the exact same time
**Solution**: Implement optimistic updates with server reconciliation

### 2. Out-of-Order Messages
**Scenario**: WebSocket messages arrive in different order than sent
**Solution**: Add message sequencing/timestamps for proper ordering

### 3. Stale State Updates
**Scenario**: Local state update conflicts with incoming WebSocket update
**Solution**: Implement state versioning and conflict resolution

### 4. Connection Race Conditions
**Scenario**: Multiple reconnection attempts or overlapping connections
**Solution**: Use connection state machine with proper cleanup

## Getting Started

1. Install dependencies: `npm install`
2. Start the development server: `npm run dev`
3. Open multiple browser tabs to test real-time features
4. Use browser dev tools to simulate network issues

## Key Files to Create/Modify

- `utils/websocket.ts` - WebSocket connection management
- `store/realtime.ts` - Real-time state management
- `components/RealTimeComments.tsx` - Real-time comments
- `components/ConnectionStatus.tsx` - Connection status UI
- `hooks/useWebSocket.ts` - WebSocket React hook
- `types/websocket.ts` - WebSocket message types

## WebSocket Message Types

```typescript
interface WebSocketMessage {
  type: 'POST_LIKED' | 'POST_UPDATED' | 'COMMENT_ADDED' | 'USER_TYPING' | 'USER_PRESENCE';
  payload: any;
  timestamp: number;
  messageId: string;
  userId: string;
}
```

## Race Condition Examples

### Example 1: Concurrent Likes
```typescript
// Problem: Two users like simultaneously
User A: POST /api/posts/1/like (likes: 5 → 6)
User B: POST /api/posts/1/like (likes: 5 → 6) // Race condition!

// Solution: Use atomic operations or optimistic locking
```

### Example 2: Message Ordering
```typescript
// Problem: Messages arrive out of order
Message 1: { type: 'POST_UPDATED', timestamp: 1000, content: 'Hello' }
Message 2: { type: 'POST_UPDATED', timestamp: 999, content: 'Hi' } // Older!

// Solution: Buffer and sort by timestamp before applying
```

## Implementation Challenges

### Connection Management
- Handle network interruptions gracefully
- Prevent multiple simultaneous connections
- Clean up resources properly
- Handle browser tab visibility changes

### State Synchronization
- Merge local and remote state changes
- Handle conflicts between optimistic and actual updates
- Maintain data consistency across tabs
- Queue operations during disconnection

### Performance
- Throttle rapid updates to prevent UI thrashing
- Batch multiple updates for efficiency
- Implement proper cleanup to prevent memory leaks
- Handle large numbers of concurrent users

## Evaluation Criteria

### Real-time Implementation (30%)
- Proper WebSocket usage
- Effective message handling
- Real-time UI updates
- Connection state management

### Race Condition Handling (25%)
- Identification of race conditions
- Proper conflict resolution
- Data consistency maintenance
- Edge case handling

### Code Quality (25%)
- Clean, maintainable code
- Proper error handling
- Resource cleanup
- TypeScript usage

### User Experience (20%)
- Smooth real-time interactions
- Clear connection status
- Graceful degradation
- Offline handling

## Tips for Success

1. **Test with multiple tabs**: Open several browser tabs to simulate multiple users
2. **Simulate network issues**: Use browser dev tools to test disconnection scenarios
3. **Handle edge cases**: What happens when WebSocket is unavailable?
4. **Use proper cleanup**: Always clean up event listeners and connections
5. **Implement optimistic updates**: Update UI immediately, then reconcile with server
6. **Add proper logging**: Debug WebSocket issues with comprehensive logging
7. **Test race conditions**: Create scenarios where multiple operations happen simultaneously

## Testing Scenarios

### Connection Management
- [ ] Test auto-reconnection after network failure
- [ ] Test multiple tab synchronization
- [ ] Test connection cleanup on page unload
- [ ] Test heartbeat mechanism

### Race Conditions
- [ ] Test concurrent likes on same post
- [ ] Test rapid comment submissions
- [ ] Test out-of-order message handling
- [ ] Test optimistic update rollbacks

### User Experience
- [ ] Test typing indicators
- [ ] Test presence indicators
- [ ] Test offline mode
- [ ] Test connection status display

Good luck! 🚀
