// User types
export interface User {
  id: string;
  name: string;
  email: string;
  avatar?: string;
  bio?: string;
  createdAt: string;
  postsCount: number;
  likesReceived: number;
}

// Post types
export interface Post {
  id: string;
  title: string;
  content: string;
  authorId: string;
  author: User;
  imageUrl?: string;
  likes: number;
  likedBy: string[]; // Array of user IDs who liked this post
  createdAt: string;
  updatedAt: string;
}

export interface CreatePostData {
  title: string;
  content: string;
  imageUrl?: string;
}

export interface UpdatePostData {
  title?: string;
  content?: string;
  imageUrl?: string;
}

// API Response types
export interface ApiResponse<T> {
  success: boolean;
  data?: T;
  error?: string;
  message?: string;
}

export interface PaginatedResponse<T> {
  data: T[];
  total: number;
  page: number;
  limit: number;
  hasMore: boolean;
}

// Store types
export interface PostsStore {
  posts: Post[];
  loading: boolean;
  error: string | null;
  
  // Actions
  fetchPosts: () => Promise<void>;
  createPost: (data: CreatePostData) => Promise<void>;
  updatePost: (id: string, data: UpdatePostData) => Promise<void>;
  deletePost: (id: string) => Promise<void>;
  likePost: (id: string, userId: string) => Promise<void>;
  clearError: () => void;
}

export interface UserStore {
  currentUser: User | null;
  users: User[];
  loading: boolean;
  error: string | null;
  
  // Actions
  setCurrentUser: (user: User) => void;
  fetchUsers: () => Promise<void>;
  clearError: () => void;
}

// Component Props types
export interface PostCardProps {
  post: Post;
  onLike?: (postId: string) => void;
  onEdit?: (post: Post) => void;
  onDelete?: (postId: string) => void;
}

export interface UserProfileProps {
  user: User;
  isCurrentUser?: boolean;
  onEdit?: () => void;
}

export interface CreatePostModalProps {
  isOpen: boolean;
  onClose: () => void;
  onSubmit: (data: CreatePostData) => void;
}

// Form types
export interface PostFormData {
  title: string;
  content: string;
  imageUrl?: string;
}

// Filter and search types
export interface PostFilters {
  authorId?: string;
  search?: string;
  sortBy?: 'date' | 'popularity';
  sortOrder?: 'asc' | 'desc';
}
