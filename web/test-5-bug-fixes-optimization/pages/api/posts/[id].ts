import type { NextApiRequest, NextApiResponse } from 'next';
import { ApiResponse, Post, UpdatePostData } from '@/types';
import { mockPosts } from '@/utils/mockData';

// TODO: Implement individual post operations
// This is a simplified in-memory implementation for testing

let posts = [...mockPosts];

export default function handler(
  req: NextApiRequest,
  res: NextApiResponse<ApiResponse<Post>>
) {
  const { id } = req.query;

  if (typeof id !== 'string') {
    return res.status(400).json({
      success: false,
      error: 'Invalid post ID',
    });
  }

  switch (req.method) {
    case 'GET':
      return handleGet(req, res, id);
    case 'PUT':
      return handlePut(req, res, id);
    case 'DELETE':
      return handleDelete(req, res, id);
    default:
      res.setHeader('Allow', ['GET', 'PUT', 'DELETE']);
      return res.status(405).json({
        success: false,
        error: `Method ${req.method} not allowed`,
      });
  }
}

function handleGet(
  req: NextApiRequest,
  res: NextApiResponse<ApiResponse<Post>>,
  id: string
) {
  // TODO: Implement GET /api/posts/[id]
  // Should return a single post by ID
  
  const post = posts.find(p => p.id === id);
  
  if (!post) {
    return res.status(404).json({
      success: false,
      error: 'Post not found',
    });
  }

  return res.status(200).json({
    success: true,
    data: post,
  });
}

function handlePut(
  req: NextApiRequest,
  res: NextApiResponse<ApiResponse<Post>>,
  id: string
) {
  // TODO: Implement PUT /api/posts/[id]
  // Should update a post and return the updated post
  // Requirements:
  // 1. Find post by ID
  // 2. Validate update data
  // 3. Check if user is the author (authorization)
  // 4. Update only provided fields
  // 5. Update the updatedAt timestamp
  
  console.log('PUT /api/posts/[id] not implemented yet');
  
  return res.status(501).json({
    success: false,
    error: 'Update functionality not implemented yet',
  });
}

function handleDelete(
  req: NextApiRequest,
  res: NextApiResponse<ApiResponse<Post>>,
  id: string
) {
  // TODO: Implement DELETE /api/posts/[id]
  // Should delete a post
  // Requirements:
  // 1. Find post by ID
  // 2. Check if user is the author (authorization)
  // 3. Remove post from array
  // 4. Return success message
  
  console.log('DELETE /api/posts/[id] not implemented yet');
  
  return res.status(501).json({
    success: false,
    error: 'Delete functionality not implemented yet',
  });
}
