# Android Developer Assessment Guide

## Overview

This assessment uses a minimal version of the YorNest Android app architecture to evaluate candidates on their ability to:

1. **Debug within our existing design patterns and stack**
2. **Add new features within our existing design patterns and stack**

The project follows the exact same architectural patterns, dependency injection setup, and coding conventions as the production YorNest app.

## Assessment Structure

### Phase 1: Architecture Understanding (15 minutes)
Ask the candidate to:
- Walk through the project structure and explain the modular architecture
- Explain the flow from UI → ViewModel → UseCase → Repository
- Identify the key architectural patterns (MVVM, Clean Architecture, Repository Pattern)
- Explain the role of Koin dependency injection

**What to look for:**
- Understanding of separation of concerns
- Recognition of the modular structure (`i_*` modules, core modules)
- Understanding of the data flow and reactive patterns
- Familiarity with dependency injection concepts

### Phase 2: Debugging Task (20-25 minutes)
Introduce a bug into the codebase before the assessment. Suggested bugs:

**Option A: Dependency Injection Issue**
- Comment out the `messagesInteractorModule` from `koinModules.kt`
- Candidate should identify the missing Koin module and fix the DI setup

**Option B: Repository Logic Issue**
- Modify `MessagesRepositoryImpl` to always return empty list
- Candidate should trace through the data flow and identify the issue

**Option C: ViewModel State Issue**
- Break the loading state management in `MessagesViewModel`
- Candidate should identify why loading indicators aren't working

**What to look for:**
- Systematic debugging approach
- Understanding of the architecture to trace issues
- Ability to use Android Studio debugging tools
- Problem-solving methodology

### Phase 3: Feature Addition (20-25 minutes)
Ask the candidate to add a simple feature. Suggested features:

**Option A: Add Message Filtering**
- Add a search/filter functionality to the messages list
- Should follow the existing patterns (new use case, repository method, ViewModel state)

**Option B: Add Pull-to-Refresh Enhancement**
- Add a "last updated" timestamp display
- Should integrate with the existing RequestData timestamp

**Option C: Add Error Retry**
- Add a retry button when errors occur
- Should integrate with the existing error handling patterns

**What to look for:**
- Following established architectural patterns
- Proper use of existing abstractions (UseCase, Repository, etc.)
- Understanding of reactive data flow with Flow/LiveData
- Code organization and naming conventions

## Technical Evaluation Criteria

### Architecture Understanding (30%)
- [ ] Understands MVVM pattern with BaseVm
- [ ] Recognizes Clean Architecture separation
- [ ] Understands modular structure and dependency flow
- [ ] Grasps the Repository pattern with RequestType

### Debugging Skills (35%)
- [ ] Systematic approach to problem identification
- [ ] Effective use of debugging tools
- [ ] Understanding of data flow for issue tracing
- [ ] Logical problem-solving process

### Implementation Skills (35%)
- [ ] Follows existing code patterns and conventions
- [ ] Proper use of architectural components
- [ ] Clean, readable code organization
- [ ] Understanding of reactive programming concepts

## Scoring Guide

**Excellent (4/4):**
- Demonstrates deep understanding of all architectural patterns
- Debugs efficiently with systematic approach
- Implements new features following exact existing patterns
- Code is clean, well-organized, and follows conventions

**Good (3/4):**
- Understands most architectural concepts with minor gaps
- Can debug with some guidance
- Implements features mostly following patterns with minor deviations
- Code is generally clean and organized

**Satisfactory (2/4):**
- Basic understanding of architecture with significant gaps
- Requires substantial guidance for debugging
- Can implement basic features but doesn't follow all patterns
- Code works but has organization or convention issues

**Needs Improvement (1/4):**
- Limited understanding of architectural concepts
- Struggles with debugging even with guidance
- Cannot implement features following existing patterns
- Code has significant issues or doesn't work

## Setup Instructions

1. **Before the Assessment:**
   - Copy `local.properties.template` to `local.properties` and update SDK path
   - Build and run the project to ensure it works
   - Introduce the chosen bug for the debugging phase
   - Prepare the feature requirements for the implementation phase

2. **During the Assessment:**
   - Share screen or use pair programming setup
   - Encourage the candidate to think out loud
   - Take notes on their approach and reasoning
   - Provide hints only if they're completely stuck

3. **After the Assessment:**
   - Review the code changes together
   - Discuss alternative approaches
   - Ask about production considerations (testing, error handling, etc.)

## Notes for Interviewers

- **Focus on process over perfect solutions** - How they approach problems is more important than getting everything perfect
- **This matches our production architecture exactly** - Success here indicates they can work effectively in our codebase
- **Look for learning ability** - Can they pick up patterns quickly and apply them consistently?
- **Consider their experience level** - Adjust expectations based on their background (junior vs senior)

The goal is to simulate real work they'd be doing on the YorNest team, so prioritize practical skills over theoretical knowledge.
