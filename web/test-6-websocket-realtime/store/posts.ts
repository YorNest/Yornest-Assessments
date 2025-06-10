import { create } from 'zustand';
import { PostsStore, Post, CreatePostData, UpdatePostData } from '@/types';
import { mockPosts, generateId, currentUser } from '@/utils/mockData';

// TODO: Complete this store implementation
// Issues to fix:
// 1. Add proper error handling
// 2. Implement missing functions
// 3. Add loading states
// 4. Fix TypeScript errors

export const usePostsStore = create<PostsStore>((set, get) => ({
  posts: [...mockPosts],
  loading: false,
  error: null,

  fetchPosts: async () => {
    // TODO: Implement this function
    // Should:
    // 1. Set loading to true
    // 2. Simulate API call (use setTimeout for 1 second)
    // 3. Update posts with mock data
    // 4. Handle errors properly
    // 5. Set loading to false
    
    console.log('fetchPosts not implemented yet');
  },

  createPost: async (data: CreatePostData) => {
    // TODO: Implement this function
    // Should:
    // 1. Validate the data
    // 2. Create a new post with generated ID
    // 3. Add current user as author
    // 4. Add to the beginning of posts array
    // 5. Handle errors
    
    console.log('createPost not implemented yet', data);
  },

  updatePost: async (id: string, data: UpdatePostData) => {
    // TODO: Implement this function
    // Should:
    // 1. Find the post by ID
    // 2. Update only the provided fields
    // 3. Update the updatedAt timestamp
    // 4. Handle case where post doesn't exist
    
    console.log('updatePost not implemented yet', id, data);
  },

  deletePost: async (id: string) => {
    // TODO: Implement this function
    // Should:
    // 1. Remove post from array
    // 2. Handle case where post doesn't exist
    // 3. Show success message
    
    console.log('deletePost not implemented yet', id);
  },

  likePost: async (id: string, userId: string) => {
    // This function has bugs - fix them!
    const posts = get().posts;
    const postIndex = posts.findIndex(p => p.id === id);
    
    if (postIndex === -1) return;
    
    const post = posts[postIndex];
    const isLiked = post.likedBy.includes(userId);
    
    // BUG: This doesn't properly update the state
    if (isLiked) {
      post.likedBy.filter(id => id !== userId);
      post.likes--;
    } else {
      post.likedBy.push(userId);
      post.likes++;
    }
    
    // BUG: This doesn't trigger a re-render
    posts[postIndex] = post;
  },

  clearError: () => {
    set({ error: null });
  },
}));
