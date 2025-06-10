import { render, screen, fireEvent } from '@testing-library/react';
import { ChakraProvider } from '@chakra-ui/react';
import PostCard from '@/components/PostCard';
import { mockPosts, mockUsers } from '@/utils/mockData';

// Mock the stores
jest.mock('@/store/users', () => ({
  useUserStore: () => ({
    currentUser: mockUsers[0],
  }),
}));

jest.mock('@/store/posts', () => ({
  usePostsStore: () => ({
    likePost: jest.fn(),
  }),
}));

const renderWithChakra = (component: React.ReactElement) => {
  return render(
    <ChakraProvider>
      {component}
    </ChakraProvider>
  );
};

describe('PostCard', () => {
  const mockPost = mockPosts[0];
  const mockOnEdit = jest.fn();
  const mockOnDelete = jest.fn();

  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('renders post content correctly', () => {
    renderWithChakra(
      <PostCard
        post={mockPost}
        onEdit={mockOnEdit}
        onDelete={mockOnDelete}
      />
    );

    expect(screen.getByText(mockPost.title)).toBeInTheDocument();
    expect(screen.getByText(mockPost.content)).toBeInTheDocument();
    expect(screen.getByText(mockPost.author.name)).toBeInTheDocument();
  });

  it('shows edit and delete buttons for post author', () => {
    renderWithChakra(
      <PostCard
        post={mockPost}
        onEdit={mockOnEdit}
        onDelete={mockOnDelete}
      />
    );

    expect(screen.getByLabelText('Edit post')).toBeInTheDocument();
    expect(screen.getByLabelText('Delete post')).toBeInTheDocument();
  });

  it('calls onEdit when edit button is clicked', () => {
    renderWithChakra(
      <PostCard
        post={mockPost}
        onEdit={mockOnEdit}
        onDelete={mockOnDelete}
      />
    );

    fireEvent.click(screen.getByLabelText('Edit post'));
    expect(mockOnEdit).toHaveBeenCalledWith(mockPost);
  });

  // TODO: Add more tests
  // - Test like functionality
  // - Test responsive design
  // - Test accessibility
  // - Test error states
});

// TODO: Add tests for other components
// - PostsList
// - UserProfile
// - CreatePostModal
