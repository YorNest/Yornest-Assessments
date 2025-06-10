import { User, Post } from '@/types';

// Mock users
export const mockUsers: User[] = [
  {
    id: '1',
    name: 'Alice Johnson',
    email: 'alice@example.com',
    avatar: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150',
    bio: 'Frontend developer passionate about React and TypeScript',
    createdAt: '2024-01-15T10:00:00Z',
    postsCount: 12,
    likesReceived: 45,
  },
  {
    id: '2',
    name: 'Bob Smith',
    email: 'bob@example.com',
    avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
    bio: 'Full-stack developer and coffee enthusiast',
    createdAt: '2024-01-10T14:30:00Z',
    postsCount: 8,
    likesReceived: 32,
  },
  {
    id: '3',
    name: 'Carol Davis',
    email: 'carol@example.com',
    avatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150',
    bio: 'UX designer who loves creating beautiful interfaces',
    createdAt: '2024-01-20T09:15:00Z',
    postsCount: 15,
    likesReceived: 67,
  },
  {
    id: '4',
    name: 'David Wilson',
    email: 'david@example.com',
    avatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150',
    bio: 'Backend engineer specializing in Node.js and databases',
    createdAt: '2024-01-05T16:45:00Z',
    postsCount: 6,
    likesReceived: 28,
  },
];

// Mock posts
export const mockPosts: Post[] = [
  {
    id: '1',
    title: 'Getting Started with Next.js 14',
    content: 'Next.js 14 introduces some amazing new features including the stable App Router, Server Components, and improved performance. Here\'s what you need to know to get started...',
    authorId: '1',
    author: mockUsers[0],
    imageUrl: 'https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=400',
    likes: 15,
    likedBy: ['2', '3', '4'],
    createdAt: '2024-01-22T10:30:00Z',
    updatedAt: '2024-01-22T10:30:00Z',
  },
  {
    id: '2',
    title: 'TypeScript Best Practices for React',
    content: 'TypeScript and React make a powerful combination. Here are some best practices I\'ve learned over the years that will help you write better, more maintainable code.',
    authorId: '2',
    author: mockUsers[1],
    likes: 23,
    likedBy: ['1', '3'],
    createdAt: '2024-01-21T14:15:00Z',
    updatedAt: '2024-01-21T14:15:00Z',
  },
  {
    id: '3',
    title: 'Designing for Accessibility',
    content: 'Accessibility isn\'t just a nice-to-have feature—it\'s essential for creating inclusive web experiences. Let me share some practical tips for making your React apps more accessible.',
    authorId: '3',
    author: mockUsers[2],
    imageUrl: 'https://images.unsplash.com/photo-1573164713714-d95e436ab8d6?w=400',
    likes: 31,
    likedBy: ['1', '2', '4'],
    createdAt: '2024-01-20T16:45:00Z',
    updatedAt: '2024-01-20T16:45:00Z',
  },
  {
    id: '4',
    title: 'Building Scalable APIs with Node.js',
    content: 'When building APIs that need to handle thousands of requests, architecture matters. Here\'s how I approach building scalable Node.js APIs that can grow with your application.',
    authorId: '4',
    author: mockUsers[3],
    likes: 18,
    likedBy: ['1', '2'],
    createdAt: '2024-01-19T11:20:00Z',
    updatedAt: '2024-01-19T11:20:00Z',
  },
  {
    id: '5',
    title: 'State Management in React: Zustand vs Redux',
    content: 'Choosing the right state management solution can make or break your React application. Let\'s compare Zustand and Redux to help you make the right choice for your project.',
    authorId: '1',
    author: mockUsers[0],
    likes: 27,
    likedBy: ['2', '3', '4'],
    createdAt: '2024-01-18T09:30:00Z',
    updatedAt: '2024-01-18T09:30:00Z',
  },
];

// Utility functions for working with mock data
export const getUserById = (id: string): User | undefined => {
  return mockUsers.find(user => user.id === id);
};

export const getPostById = (id: string): Post | undefined => {
  return mockPosts.find(post => post.id === id);
};

export const getPostsByAuthor = (authorId: string): Post[] => {
  return mockPosts.filter(post => post.authorId === authorId);
};

export const generateId = (): string => {
  return Math.random().toString(36).substr(2, 9);
};

// Current user (for testing purposes)
export const currentUser = mockUsers[0];
