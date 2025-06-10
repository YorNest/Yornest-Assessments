# Test 1: Component Development (30 minutes)

## Overview
This test focuses on React component development skills, including fixing existing components and creating new ones from scratch.

## Tasks

### 1.1 Fix PostCard Component
**File**: `components/PostCard.tsx`

**Issues to fix**:
- [ ] TypeScript error: `currentUser` might be null (line 47)
- [ ] Like functionality doesn't work properly (handleLike function)
- [ ] Missing hover effects on the card
- [ ] No loading state for like button
- [ ] Poor responsive design

**Requirements**:
- Add proper null checks for currentUser
- Implement working like functionality using the store
- Add hover effects (subtle shadow, transform)
- Add loading state when liking a post
- Make the card responsive (stack elements on mobile)

### 1.2 Create UserProfile Component
**File**: `components/UserProfile.tsx`

**Current state**: Placeholder component that needs to be built from scratch

**Requirements**:
- Display user avatar with fallback for missing images
- Show user name and bio
- Display user stats (posts count, likes received) in a nice layout
- Add edit button for current user (only show if `isCurrentUser` is true)
- Make it responsive
- Handle long names and bios gracefully
- Add proper TypeScript types

**Design suggestions**:
- Use Card component from Chakra UI
- Center-align avatar and name
- Use StatGroup for displaying stats
- Add subtle animations

## Getting Started

1. Install dependencies: `npm install`
2. Start the development server: `npm run dev`
3. Open http://localhost:3000 in your browser
4. Begin working on the components

## Evaluation Criteria

### Code Quality (25%)
- Clean, readable code
- Proper TypeScript usage
- Good component structure
- Consistent naming conventions

### Functionality (25%)
- Features work as expected
- Proper error handling
- Good user experience
- Edge cases handled

### React Best Practices (25%)
- Proper hooks usage
- Component composition
- State management
- Performance considerations

### Problem Solving (25%)
- Debugging skills
- Architectural decisions
- Trade-off considerations
- Documentation and comments

## Tips for Success

1. **Start with TypeScript errors**: Fix them first to ensure type safety
2. **Test in the browser**: Check your changes frequently
3. **Read existing code**: Understand the patterns before making changes
4. **Focus on user experience**: Think about how users will interact with your components
5. **Handle edge cases**: What happens when there's no data, loading states, etc.

Good luck! 🚀
