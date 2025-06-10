# Test 5: Bug Fixes & Optimization (20 minutes)

## Overview
This test focuses on identifying and fixing bugs, optimizing performance, and improving code quality.

## Tasks

### 5.1 Fix Performance Issues
**File**: `components/PostsList.tsx`

**Issues**:
- [ ] Functions recreate on every render (handleEdit, handleDelete)
- [ ] No memoization of expensive operations
- [ ] Inefficient rendering of large lists

**Solutions**:
- Use useCallback for event handlers
- Memoize the component with React.memo
- Consider virtualization for large lists
- Optimize re-renders

### 5.2 Fix TypeScript Errors
Run `npm run type-check` and fix all TypeScript errors:
- [ ] Missing type definitions
- [ ] Incorrect prop types
- [ ] Unused variables
- [ ] Any types that should be properly typed

### 5.3 Improve Accessibility
- [ ] Add proper ARIA labels
- [ ] Ensure keyboard navigation works
- [ ] Add focus management for modals
- [ ] Check color contrast
- [ ] Add alt text for images

## Getting Started

1. Install dependencies: `npm install`
2. Run type checking: `npm run type-check`
3. Start the development server: `npm run dev`
4. Open browser dev tools to check for console errors
5. Test with keyboard navigation and screen readers

## Key Files to Focus On

- `components/PostsList.tsx` - Performance optimization
- `components/CreatePostModal.tsx` - Accessibility improvements
- `components/PostCard.tsx` - TypeScript fixes
- All component files - General bug fixes

## Performance Optimization Checklist

### PostsList Component
- [ ] Wrap event handlers in useCallback
- [ ] Memoize the component with React.memo
- [ ] Optimize prop passing to child components
- [ ] Consider useMemo for expensive calculations
- [ ] Check for unnecessary re-renders

### General Performance
- [ ] Remove unused imports and variables
- [ ] Optimize bundle size
- [ ] Check for memory leaks
- [ ] Optimize image loading

## TypeScript Fixes

### Common Issues to Look For
- [ ] `any` types that should be properly typed
- [ ] Missing prop type definitions
- [ ] Incorrect return types
- [ ] Unused variables and imports
- [ ] Missing null checks

### Tools to Use
```bash
npm run type-check  # Check for TypeScript errors
npm run lint        # Check for linting issues
```

## Accessibility Improvements

### Keyboard Navigation
- [ ] All interactive elements are focusable
- [ ] Tab order is logical
- [ ] Escape key closes modals
- [ ] Enter/Space activate buttons

### Screen Reader Support
- [ ] Proper ARIA labels on form inputs
- [ ] ARIA descriptions for complex interactions
- [ ] Proper heading hierarchy
- [ ] Alt text for images

### Visual Accessibility
- [ ] Sufficient color contrast
- [ ] Focus indicators are visible
- [ ] Text is readable at 200% zoom
- [ ] No reliance on color alone for information

## Evaluation Criteria

### Performance (30%)
- Efficient re-rendering
- Proper memoization
- Optimized event handlers
- Bundle size optimization

### Code Quality (25%)
- TypeScript compliance
- Clean, readable code
- Proper error handling
- Consistent patterns

### Accessibility (25%)
- Keyboard navigation
- Screen reader support
- ARIA compliance
- Visual accessibility

### Bug Fixes (20%)
- Identification of issues
- Proper solutions
- Testing fixes
- Prevention of regressions

## Tips for Success

1. **Use React DevTools**: Profile components to find performance issues
2. **Test with keyboard only**: Navigate without using a mouse
3. **Use screen reader**: Test with VoiceOver (Mac) or NVDA (Windows)
4. **Check TypeScript strictly**: Fix all errors, not just warnings
5. **Measure performance**: Use browser dev tools to measure improvements
6. **Test edge cases**: Large lists, slow networks, etc.

## Testing Tools

### Performance
- React DevTools Profiler
- Chrome DevTools Performance tab
- Lighthouse performance audit

### Accessibility
- axe DevTools browser extension
- WAVE Web Accessibility Evaluator
- Keyboard navigation testing
- Screen reader testing

### TypeScript
```bash
npm run type-check
npm run lint
```

Good luck! 🚀
