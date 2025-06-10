# Test 4: Feature Implementation (35 minutes)

## Overview
This test focuses on implementing complete features, including form handling, validation, and filtering functionality.

## Tasks

### 4.1 Complete CreatePostModal
**File**: `components/CreatePostModal.tsx`

**Current state**: Basic form structure exists but functionality is missing

**Requirements**:
- [ ] Implement form validation (title and content required)
- [ ] Add character limits (title: 200, content: 5000)
- [ ] Show validation errors to user
- [ ] Implement form submission with loading state
- [ ] Reset form after successful submission
- [ ] Handle API errors gracefully
- [ ] Add image URL validation (optional field)

### 4.2 Implement Post Filtering
**File**: `pages/index.tsx`

**Current state**: Basic filter UI exists but doesn't work properly

**Requirements**:
- [ ] Make search filter work (search in title, content, author name)
- [ ] Implement author filter (add dropdown with all authors)
- [ ] Fix sorting functionality
- [ ] Add debouncing to search input
- [ ] Show "No results" state when filters return empty
- [ ] Add clear filters button

## Getting Started

1. Install dependencies: `npm install`
2. Start the development server: `npm run dev`
3. Open http://localhost:3000 in your browser
4. Test the create post modal and filtering features

## Key Files to Focus On

- `components/CreatePostModal.tsx` - Form implementation
- `pages/index.tsx` - Filtering functionality
- `utils/validation.ts` - Form validation helpers
- `store/posts.ts` - State management for posts

## Feature Requirements Details

### CreatePostModal Features
- **Form Validation**: Real-time validation with error messages
- **Character Limits**: Visual indicators for remaining characters
- **Loading States**: Disable form during submission
- **Error Handling**: Show API errors to user
- **Success Handling**: Close modal and show success message

### Post Filtering Features
- **Search**: Filter by title, content, and author name
- **Author Filter**: Dropdown with all unique authors
- **Sorting**: By date (newest/oldest) and popularity (most/least liked)
- **Debouncing**: Prevent excessive API calls during typing
- **Clear Filters**: Reset all filters to default state
- **Empty State**: Show message when no posts match filters

## Evaluation Criteria

### User Experience (30%)
- Intuitive interface
- Clear feedback to user
- Smooth interactions
- Proper loading states

### Form Handling (25%)
- Proper validation
- Error handling
- Data submission
- Form reset functionality

### Filtering Logic (25%)
- Accurate search results
- Proper sorting
- Performance optimization
- Edge case handling

### Code Quality (20%)
- Clean, readable code
- Proper TypeScript usage
- Component structure
- State management

## Tips for Success

1. **Focus on UX**: Users should always know what's happening
2. **Validate early**: Show validation errors as users type
3. **Debounce search**: Prevent excessive filtering during typing
4. **Handle empty states**: Show helpful messages when no results
5. **Test edge cases**: Empty inputs, special characters, long text
6. **Use proper loading states**: Disable interactions during operations

## Testing Checklist

### CreatePostModal
- [ ] Form validation works for all fields
- [ ] Character limits are enforced and displayed
- [ ] Form submits successfully
- [ ] Loading state shows during submission
- [ ] Form resets after successful submission
- [ ] Error messages display for API failures

### Post Filtering
- [ ] Search works across title, content, and author
- [ ] Author dropdown shows all unique authors
- [ ] Sorting works for date and popularity
- [ ] Search is debounced (doesn't filter on every keystroke)
- [ ] Clear filters button resets everything
- [ ] "No results" message shows when appropriate

Good luck! 🚀
