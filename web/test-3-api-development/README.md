# Test 3: API Development (25 minutes)

## Overview
This test focuses on Next.js API route development, including implementing CRUD operations and proper error handling.

## Tasks

### 3.1 Complete Posts API
**Files**: `pages/api/posts/index.ts`, `pages/api/posts/[id].ts`

**GET /api/posts**:
- [ ] Add query parameters for filtering:
  - `search`: Filter by title/content
  - `authorId`: Filter by author
  - `limit` & `offset`: Pagination
  - `sortBy`: 'date' or 'popularity'
  - `sortOrder`: 'asc' or 'desc'

**POST /api/posts**:
- [ ] Add comprehensive validation
- [ ] Sanitize input data
- [ ] Return proper error messages

**PUT /api/posts/[id]**:
- [ ] Implement update functionality
- [ ] Validate that user is the author
- [ ] Update only provided fields
- [ ] Update `updatedAt` timestamp

**DELETE /api/posts/[id]**:
- [ ] Implement delete functionality
- [ ] Validate that user is the author
- [ ] Return success message

### 3.2 Error Handling
- Return appropriate HTTP status codes
- Provide clear error messages
- Handle malformed requests
- Add request validation

## Getting Started

1. Install dependencies: `npm install`
2. Start the development server: `npm run dev`
3. Test API endpoints using:
   - Browser for GET requests
   - Postman/Insomnia for POST/PUT/DELETE
   - Or use the frontend to test integration

## Key Files to Focus On

- `pages/api/posts/index.ts` - GET and POST endpoints
- `pages/api/posts/[id].ts` - PUT and DELETE endpoints
- `utils/validation.ts` - Input validation helpers
- `utils/mockData.ts` - Sample data for testing

## Testing Your API

### GET /api/posts
```bash
curl http://localhost:3000/api/posts
curl "http://localhost:3000/api/posts?search=react&limit=5"
```

### POST /api/posts
```bash
curl -X POST http://localhost:3000/api/posts \
  -H "Content-Type: application/json" \
  -d '{"title":"Test Post","content":"Test content","authorId":"1"}'
```

### PUT /api/posts/[id]
```bash
curl -X PUT http://localhost:3000/api/posts/1 \
  -H "Content-Type: application/json" \
  -d '{"title":"Updated Title"}'
```

### DELETE /api/posts/[id]
```bash
curl -X DELETE http://localhost:3000/api/posts/1
```

## Evaluation Criteria

### API Design (30%)
- RESTful principles
- Proper HTTP methods
- Clear endpoint structure
- Consistent response format

### Error Handling (25%)
- Appropriate status codes
- Clear error messages
- Input validation
- Edge case handling

### Code Quality (25%)
- Clean, readable code
- Proper TypeScript usage
- Good function structure
- Consistent patterns

### Functionality (20%)
- All endpoints work correctly
- Proper data manipulation
- Correct filtering/sorting
- Proper validation

## Tips for Success

1. **Follow REST conventions**: Use proper HTTP methods and status codes
2. **Validate all inputs**: Never trust client data
3. **Return consistent responses**: Use the same format for all endpoints
4. **Handle edge cases**: What happens with invalid IDs, missing data, etc.
5. **Test thoroughly**: Use different tools to test your endpoints

Good luck! 🚀
