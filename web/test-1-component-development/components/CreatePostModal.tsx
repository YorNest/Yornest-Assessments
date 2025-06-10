import {
  Modal,
  ModalOverlay,
  ModalContent,
  ModalHeader,
  ModalFooter,
  ModalBody,
  ModalCloseButton,
  Button,
  FormControl,
  FormLabel,
  Input,
  Textarea,
  VStack,
  useToast,
} from '@chakra-ui/react';
import { useState } from 'react';
import { CreatePostModalProps, PostFormData } from '@/types';

// TODO: Complete this modal component
// Requirements:
// 1. Form with title, content, and optional image URL
// 2. Form validation (title and content required)
// 3. Proper error handling and success feedback
// 4. Loading state during submission
// 5. Reset form after successful submission

const CreatePostModal = ({ isOpen, onClose, onSubmit }: CreatePostModalProps) => {
  const toast = useToast();
  const [loading, setLoading] = useState(false);
  const [formData, setFormData] = useState<PostFormData>({
    title: '',
    content: '',
    imageUrl: '',
  });

  // TODO: Add form validation
  const validateForm = (): boolean => {
    // Implement validation logic
    return true;
  };

  const handleSubmit = async () => {
    // TODO: Implement form submission
    // 1. Validate form data
    // 2. Set loading state
    // 3. Call onSubmit prop
    // 4. Handle success/error
    // 5. Reset form and close modal
    
    console.log('Form submission not implemented', formData);
  };

  const handleInputChange = (field: keyof PostFormData, value: string) => {
    setFormData(prev => ({ ...prev, [field]: value }));
  };

  const handleClose = () => {
    // TODO: Reset form when closing
    onClose();
  };

  return (
    <Modal isOpen={isOpen} onClose={handleClose} size="lg">
      <ModalOverlay />
      <ModalContent>
        <ModalHeader>Create New Post</ModalHeader>
        <ModalCloseButton />
        
        <ModalBody>
          <VStack spacing={4}>
            <FormControl isRequired>
              <FormLabel>Title</FormLabel>
              <Input
                placeholder="Enter post title..."
                value={formData.title}
                onChange={(e) => handleInputChange('title', e.target.value)}
              />
            </FormControl>

            <FormControl isRequired>
              <FormLabel>Content</FormLabel>
              <Textarea
                placeholder="What's on your mind?"
                value={formData.content}
                onChange={(e) => handleInputChange('content', e.target.value)}
                rows={6}
              />
            </FormControl>

            <FormControl>
              <FormLabel>Image URL (optional)</FormLabel>
              <Input
                placeholder="https://example.com/image.jpg"
                value={formData.imageUrl}
                onChange={(e) => handleInputChange('imageUrl', e.target.value)}
              />
            </FormControl>
          </VStack>
        </ModalBody>

        <ModalFooter>
          <Button variant="ghost" mr={3} onClick={handleClose}>
            Cancel
          </Button>
          <Button
            onClick={handleSubmit}
            isLoading={loading}
            loadingText="Creating..."
          >
            Create Post
          </Button>
        </ModalFooter>
      </ModalContent>
    </Modal>
  );
};

export default CreatePostModal;
