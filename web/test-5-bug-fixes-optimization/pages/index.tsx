import { useEffect, useState } from 'react';
import {
  Box,
  Container,
  Heading,
  Button,
  Flex,
  Spacer,
  useDisclosure,
  Input,
  Select,
  HStack,
  Text,
} from '@chakra-ui/react';
import { AddIcon } from '@chakra-ui/icons';
import Head from 'next/head';

import PostsList from '@/components/PostsList';
import CreatePostModal from '@/components/CreatePostModal';
import UserProfile from '@/components/UserProfile';
import { usePostsStore } from '@/store/posts';
import { useUserStore } from '@/store/users';
import { PostFilters } from '@/types';

export default function Home() {
  const { isOpen, onOpen, onClose } = useDisclosure();
  const { posts, fetchPosts, createPost } = usePostsStore();
  const { currentUser } = useUserStore();
  
  const [filters, setFilters] = useState<PostFilters>({
    search: '',
    sortBy: 'date',
    sortOrder: 'desc',
  });

  useEffect(() => {
    fetchPosts();
  }, [fetchPosts]);

  const handleCreatePost = async (data: any) => {
    await createPost(data);
    onClose();
  };

  const handleFilterChange = (key: keyof PostFilters, value: string) => {
    setFilters(prev => ({ ...prev, [key]: value }));
  };

  // Filter and sort posts based on current filters
  const filteredPosts = posts
    .filter(post => {
      if (filters.search) {
        const searchLower = filters.search.toLowerCase();
        return (
          post.title.toLowerCase().includes(searchLower) ||
          post.content.toLowerCase().includes(searchLower) ||
          post.author.name.toLowerCase().includes(searchLower)
        );
      }
      return true;
    })
    .filter(post => {
      if (filters.authorId) {
        return post.authorId === filters.authorId;
      }
      return true;
    })
    .sort((a, b) => {
      if (filters.sortBy === 'date') {
        const dateA = new Date(a.createdAt).getTime();
        const dateB = new Date(b.createdAt).getTime();
        return filters.sortOrder === 'desc' ? dateB - dateA : dateA - dateB;
      } else if (filters.sortBy === 'popularity') {
        return filters.sortOrder === 'desc' ? b.likes - a.likes : a.likes - b.likes;
      }
      return 0;
    });

  return (
    <>
      <Head>
        <title>Scoop - Share Your Thoughts</title>
        <meta name="description" content="A social platform for sharing ideas and connecting with others" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <Container maxW="6xl" py={8}>
        <Flex direction={{ base: 'column', lg: 'row' }} gap={8}>
          {/* Main Content */}
          <Box flex={1}>
            {/* Header */}
            <Flex align="center" mb={6}>
              <Heading size="lg" color="gray.800">
                Latest Posts
              </Heading>
              <Spacer />
              <Button
                leftIcon={<AddIcon />}
                onClick={onOpen}
                size="md"
              >
                Create Post
              </Button>
            </Flex>

            {/* Filters */}
            <Box mb={6} p={4} bg="white" borderRadius="lg" boxShadow="sm">
              <Text mb={3} fontWeight="semibold" color="gray.700">
                Filter & Sort
              </Text>
              <HStack spacing={4} wrap="wrap">
                <Input
                  placeholder="Search posts..."
                  value={filters.search}
                  onChange={(e) => handleFilterChange('search', e.target.value)}
                  maxW="300px"
                />
                <Select
                  value={filters.sortBy}
                  onChange={(e) => handleFilterChange('sortBy', e.target.value)}
                  maxW="150px"
                >
                  <option value="date">Date</option>
                  <option value="popularity">Popularity</option>
                </Select>
                <Select
                  value={filters.sortOrder}
                  onChange={(e) => handleFilterChange('sortOrder', e.target.value)}
                  maxW="150px"
                >
                  <option value="desc">Newest First</option>
                  <option value="asc">Oldest First</option>
                </Select>
              </HStack>
            </Box>

            {/* Posts List */}
            <PostsList posts={filteredPosts} />
          </Box>

          {/* Sidebar */}
          <Box w={{ base: 'full', lg: '300px' }}>
            {currentUser && (
              <UserProfile user={currentUser} isCurrentUser={true} />
            )}
          </Box>
        </Flex>

        {/* Create Post Modal */}
        <CreatePostModal
          isOpen={isOpen}
          onClose={onClose}
          onSubmit={handleCreatePost}
        />
      </Container>
    </>
  );
}
