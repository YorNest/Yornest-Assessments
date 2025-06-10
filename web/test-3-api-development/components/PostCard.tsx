import {
  Box,
  Card,
  CardBody,
  Heading,
  Text,
  Avatar,
  HStack,
  VStack,
  Button,
  Image,
  Flex,
  Spacer,
  IconButton,
  useToast,
} from '@chakra-ui/react';
import { FiHeart, FiEdit, FiTrash2 } from 'react-icons/fi';
import { PostCardProps } from '@/types';
import { useUserStore } from '@/store/users';
import { usePostsStore } from '@/store/posts';

// TODO: Fix the TypeScript errors and implement missing functionality
// Issues to fix:
// 1. TypeScript errors with props
// 2. Like functionality doesn't work
// 3. Missing hover effects
// 4. No loading states
// 5. Poor responsive design

const PostCard = ({ post, onEdit, onDelete }: PostCardProps) => {
  const toast = useToast();
  const { currentUser } = useUserStore();
  const { likePost } = usePostsStore();

  // BUG: This function has issues
  const handleLike = async () => {
    if (!currentUser) {
      toast({
        title: 'Please log in to like posts',
        status: 'warning',
        duration: 3000,
      });
      return;
    }

    // TODO: Implement proper like functionality
    // Should call likePost from store and handle errors
    console.log('Like functionality not implemented');
  };

  const handleEdit = () => {
    if (onEdit) {
      onEdit(post);
    }
  };

  const handleDelete = () => {
    if (onDelete) {
      onDelete(post.id);
    }
  };

  // BUG: Missing null checks
  const isLiked = post.likedBy.includes(currentUser.id);
  const isAuthor = post.authorId === currentUser.id;

  // Format date - this could be improved
  const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleDateString();
  };

  return (
    <Card
      mb={4}
      // TODO: Add hover effects
      // TODO: Add proper responsive design
    >
      <CardBody>
        <VStack align="stretch" spacing={4}>
          {/* Author Info */}
          <HStack>
            <Avatar
              size="sm"
              src={post.author.avatar}
              name={post.author.name}
            />
            <VStack align="start" spacing={0}>
              <Text fontWeight="semibold" fontSize="sm">
                {post.author.name}
              </Text>
              <Text fontSize="xs" color="gray.500">
                {formatDate(post.createdAt)}
              </Text>
            </VStack>
            <Spacer />
            
            {/* Action buttons for post author */}
            {isAuthor && (
              <HStack>
                <IconButton
                  aria-label="Edit post"
                  icon={<FiEdit />}
                  size="sm"
                  variant="ghost"
                  onClick={handleEdit}
                />
                <IconButton
                  aria-label="Delete post"
                  icon={<FiTrash2 />}
                  size="sm"
                  variant="ghost"
                  colorScheme="red"
                  onClick={handleDelete}
                />
              </HStack>
            )}
          </HStack>

          {/* Post Content */}
          <Box>
            <Heading size="md" mb={2}>
              {post.title}
            </Heading>
            <Text color="gray.600" lineHeight="tall">
              {post.content}
            </Text>
          </Box>

          {/* Post Image */}
          {post.imageUrl && (
            <Image
              src={post.imageUrl}
              alt={post.title}
              borderRadius="md"
              maxH="300px"
              objectFit="cover"
              w="full"
            />
          )}

          {/* Actions */}
          <Flex align="center">
            <Button
              leftIcon={<FiHeart />}
              variant="ghost"
              size="sm"
              onClick={handleLike}
              // TODO: Add proper styling for liked state
              colorScheme={isLiked ? 'red' : 'gray'}
            >
              {post.likes}
            </Button>
            <Spacer />
          </Flex>
        </VStack>
      </CardBody>
    </Card>
  );
};

export default PostCard;
