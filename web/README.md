# Web Development Assessment Tests

This directory contains multiple focused web development tests. Each test folder is a complete, standalone assessment that can be zipped and sent to candidates.

## Available Tests

### [Test 1: Component Development](./test-1-component-development/) (30 minutes)
**Focus**: React component development, TypeScript, UI implementation
- Fix PostCard component issues (null checks, like functionality, responsive design)
- Create UserProfile component from scratch
- Implement hover effects and loading states

### [Test 2: State Management](./test-2-state-management/) (20 minutes)
**Focus**: Zustand store implementation, state synchronization
- Complete posts store functions (fetchPosts, createPost, updatePost, deletePost)
- Fix likePost function bugs
- Connect components to store with proper error handling

### [Test 3: API Development](./test-3-api-development/) (25 minutes)
**Focus**: Next.js API routes, REST principles, validation
- Implement CRUD operations for posts API
- Add query parameters for filtering and pagination
- Implement proper error handling and validation

### [Test 4: Feature Implementation](./test-4-feature-implementation/) (35 minutes)
**Focus**: Complete feature development, form handling, filtering
- Complete CreatePostModal with validation and error handling
- Implement post filtering with search, author filter, and sorting
- Add debouncing and empty states

### [Test 5: Bug Fixes & Optimization](./test-5-bug-fixes-optimization/) (20 minutes)
**Focus**: Performance optimization, TypeScript fixes, accessibility
- Fix performance issues in PostsList component
- Resolve all TypeScript errors
- Improve accessibility with ARIA labels and keyboard navigation

### [Test 6: WebSocket & Real-time Features](./test-6-websocket-realtime/) (30 minutes)
**Focus**: Real-time features, race condition handling, WebSocket management
- Implement WebSocket connection with auto-reconnection
- Handle race conditions in concurrent likes and updates
- Create real-time comments system with typing indicators

## How to Use

1. **Choose a test** based on the skills you want to assess
2. **Zip the test folder** and send to the candidate
3. **Provide time limit** as specified for each test
4. **Review the candidate's solution** against the evaluation criteria in each test's README

## Test Structure

Each test folder contains:
- **README.md** - Detailed instructions and evaluation criteria
- **Complete codebase** - All necessary files to run the application
- **Focused tasks** - Specific requirements for that test area
- **Getting started guide** - How to set up and run the project
- **Tips for success** - Guidance for candidates

## Tech Stack (All Tests)

- **Next.js 13** - React framework
- **React 18** - UI library
- **TypeScript** - Type safety
- **Chakra UI** - Component library
- **Zustand** - State management
- **Jest & React Testing Library** - Testing

## Candidate Instructions

Each test is designed to be:
- **Self-contained** - No external dependencies needed
- **Time-boxed** - Clear time limits for focused assessment
- **Realistic** - Based on real-world development scenarios
- **Measurable** - Clear evaluation criteria provided

## For Interviewers

### Evaluation Areas
- **Code Quality** - Clean, readable, maintainable code
- **Problem Solving** - Approach to debugging and implementation
- **Best Practices** - Following React/Next.js conventions
- **User Experience** - Consideration for end-user needs

### Tips for Assessment
1. Focus on the candidate's thought process, not just the final result
2. Ask about trade-offs and alternative approaches
3. Discuss how they would extend or scale their solution
4. Review their testing strategy and error handling approach
