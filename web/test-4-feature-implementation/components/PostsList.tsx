import { Box, Text, Spinner, Center, VStack } from '@chakra-ui/react';
import PostCard from './PostCard';
import { Post } from '@/types';
import { usePostsStore } from '@/store/posts';

interface PostsListProps {
  posts: Post[];
}

// TODO: Fix performance issues in this component
// Issues:
// 1. No memoization - re-renders unnecessarily
// 2. Inefficient rendering of large lists
// 3. No virtualization for long lists
// 4. Missing loading and error states

const PostsList = ({ posts }: PostsListProps) => {
  const { loading, error, deletePost } = usePostsStore();

  // BUG: This function recreates on every render
  const handleEdit = (post: Post) => {
    console.log('Edit post:', post.id);
    // TODO: Implement edit functionality
  };

  // BUG: This function recreates on every render
  const handleDelete = async (postId: string) => {
    if (window.confirm('Are you sure you want to delete this post?')) {
      await deletePost(postId);
    }
  };

  if (loading) {
    return (
      <Center py={8}>
        <VStack>
          <Spinner size="lg" color="brand.500" />
          <Text>Loading posts...</Text>
        </VStack>
      </Center>
    );
  }

  if (error) {
    return (
      <Center py={8}>
        <Text color="red.500">Error: {error}</Text>
      </Center>
    );
  }

  if (posts.length === 0) {
    return (
      <Center py={8}>
        <VStack>
          <Text fontSize="lg" color="gray.500">
            No posts found
          </Text>
          <Text color="gray.400">
            Be the first to share something!
          </Text>
        </VStack>
      </Center>
    );
  }

  return (
    <Box>
      {/* TODO: Add virtualization for better performance with large lists */}
      {posts.map((post) => (
        <PostCard
          key={post.id}
          post={post}
          onEdit={handleEdit}
          onDelete={handleDelete}
        />
      ))}
    </Box>
  );
};

export default PostsList;
