import type { NextApiRequest, NextApiResponse } from 'next';
import { ApiResponse, Post, CreatePostData } from '@/types';
import { mockPosts, generateId, currentUser } from '@/utils/mockData';

// TODO: Implement proper API endpoints
// This is a simplified in-memory implementation for testing
// In a real app, this would connect to a database

let posts = [...mockPosts];

export default function handler(
  req: NextApiRequest,
  res: NextApiResponse<ApiResponse<Post | Post[]>>
) {
  switch (req.method) {
    case 'GET':
      return handleGet(req, res);
    case 'POST':
      return handlePost(req, res);
    default:
      res.setHeader('Allow', ['GET', 'POST']);
      return res.status(405).json({
        success: false,
        error: `Method ${req.method} not allowed`,
      });
  }
}

function handleGet(
  req: NextApiRequest,
  res: NextApiResponse<ApiResponse<Post[]>>
) {
  try {
    // TODO: Add query parameters for filtering and pagination
    // - search: string
    // - authorId: string
    // - limit: number
    // - offset: number
    // - sortBy: 'date' | 'popularity'
    // - sortOrder: 'asc' | 'desc'

    // For now, just return all posts
    return res.status(200).json({
      success: true,
      data: posts,
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      error: 'Failed to fetch posts',
    });
  }
}

function handlePost(
  req: NextApiRequest,
  res: NextApiResponse<ApiResponse<Post>>
) {
  try {
    // TODO: Add proper validation
    // 1. Validate required fields (title, content)
    // 2. Sanitize input data
    // 3. Check title length (max 200 chars)
    // 4. Check content length (max 5000 chars)
    // 5. Validate image URL format if provided

    const { title, content, imageUrl }: CreatePostData = req.body;

    // Basic validation (you should improve this)
    if (!title || !content) {
      return res.status(400).json({
        success: false,
        error: 'Title and content are required',
      });
    }

    // Create new post
    const newPost: Post = {
      id: generateId(),
      title,
      content,
      imageUrl,
      authorId: currentUser.id,
      author: currentUser,
      likes: 0,
      likedBy: [],
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
    };

    // Add to posts array (in a real app, save to database)
    posts.unshift(newPost);

    return res.status(201).json({
      success: true,
      data: newPost,
      message: 'Post created successfully',
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      error: 'Failed to create post',
    });
  }
}
