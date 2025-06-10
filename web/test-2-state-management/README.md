# Test 2: State Management (20 minutes)

## Overview
This test focuses on state management using Zustand, including implementing store functions and connecting components to the store.

## Tasks

### 2.1 Complete Posts Store
**File**: `store/posts.ts`

**Functions to implement**:
- [ ] `fetchPosts`: Simulate API call, handle loading states
- [ ] `createPost`: Add new post to beginning of array
- [ ] `updatePost`: Find and update existing post
- [ ] `deletePost`: Remove post from array
- [ ] Fix `likePost`: Currently has bugs with state updates

**Requirements**:
- Add proper error handling for all functions
- Use proper loading states
- Ensure state updates trigger re-renders
- Add input validation
- Handle edge cases (post not found, etc.)

### 2.2 Connect Components
- Make PostCard use the store's likePost function
- Ensure PostsList shows loading states from store
- Handle errors gracefully with toast notifications

## Getting Started

1. Install dependencies: `npm install`
2. Start the development server: `npm run dev`
3. Open http://localhost:3000 in your browser
4. Begin working on the store implementation

## Key Files to Focus On

- `store/posts.ts` - Main store implementation
- `components/PostCard.tsx` - Connect like functionality
- `components/PostsList.tsx` - Show loading states
- `utils/mockData.ts` - Sample data for testing

## Evaluation Criteria

### State Management (30%)
- Proper Zustand usage
- Clean store structure
- Efficient state updates
- Proper loading states

### Error Handling (25%)
- Graceful error handling
- User-friendly error messages
- Proper error boundaries
- Network error handling

### Component Integration (25%)
- Proper store connection
- Efficient re-renders
- Clean component code
- Proper hooks usage

### Code Quality (20%)
- TypeScript usage
- Clean, readable code
- Proper validation
- Edge case handling

## Tips for Success

1. **Understand Zustand patterns**: Review the existing store structure
2. **Test state changes**: Use React DevTools to monitor state
3. **Handle loading states**: Users should know when operations are in progress
4. **Validate inputs**: Ensure data integrity before state updates
5. **Think about edge cases**: What happens when operations fail?

Good luck! 🚀
