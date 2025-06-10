// Validation utilities

export interface ValidationResult {
  isValid: boolean;
  errors: string[];
}

export function validatePost(data: {
  title?: string;
  content?: string;
  imageUrl?: string;
}): ValidationResult {
  const errors: string[] = [];

  // Title validation
  if (!data.title || data.title.trim().length === 0) {
    errors.push('Title is required');
  } else if (data.title.length > 200) {
    errors.push('Title must be less than 200 characters');
  }

  // Content validation
  if (!data.content || data.content.trim().length === 0) {
    errors.push('Content is required');
  } else if (data.content.length > 5000) {
    errors.push('Content must be less than 5000 characters');
  }

  // Image URL validation (optional)
  if (data.imageUrl && data.imageUrl.trim().length > 0) {
    const urlPattern = /^https?:\/\/.+\.(jpg|jpeg|png|gif|webp)$/i;
    if (!urlPattern.test(data.imageUrl)) {
      errors.push('Image URL must be a valid image URL');
    }
  }

  return {
    isValid: errors.length === 0,
    errors,
  };
}

export function validateEmail(email: string): boolean {
  const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailPattern.test(email);
}

export function sanitizeInput(input: string): string {
  return input.trim().replace(/[<>]/g, '');
}

// TODO: Add more validation functions as needed
// TODO: Add password validation
// TODO: Add phone number validation
