import {
  Box,
  Card,
  CardBody,
  Avatar,
  Heading,
  Text,
  VStack,
  HStack,
  Button,
  Stat,
  StatLabel,
  StatNumber,
  StatGroup,
} from '@chakra-ui/react';
import { FiEdit } from 'react-icons/fi';
import { UserProfileProps } from '@/types';

// TODO: Create this component from scratch
// Requirements:
// 1. Display user avatar, name, and bio
// 2. Show user stats (posts count, likes received)
// 3. Make it responsive
// 4. Add edit button for current user
// 5. Handle missing avatar gracefully
// 6. Add proper TypeScript types

const UserProfile = ({ user, isCurrentUser = false, onEdit }: UserProfileProps) => {
  // TODO: Implement this component
  // This is just a placeholder - you need to build the actual component
  
  return (
    <Card>
      <CardBody>
        <VStack spacing={4} align="center">
          {/* TODO: Add user avatar */}
          
          {/* TODO: Add user name and bio */}
          
          {/* TODO: Add user stats */}
          
          {/* TODO: Add edit button for current user */}
          
          <Text color="gray.500" fontSize="sm">
            Component not implemented yet
          </Text>
        </VStack>
      </CardBody>
    </Card>
  );
};

export default UserProfile;
