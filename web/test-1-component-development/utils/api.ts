// API utility functions for making HTTP requests

export class ApiError extends Error {
  constructor(public status: number, message: string) {
    super(message);
    this.name = 'ApiError';
  }
}

export async function apiRequest<T>(
  url: string,
  options: RequestInit = {}
): Promise<T> {
  const response = await fetch(url, {
    headers: {
      'Content-Type': 'application/json',
      ...options.headers,
    },
    ...options,
  });

  if (!response.ok) {
    throw new ApiError(response.status, `HTTP error! status: ${response.status}`);
  }

  return response.json();
}

// Posts API functions
export const postsApi = {
  getAll: () => apiRequest<any>('/api/posts'),
  getById: (id: string) => apiRequest<any>(`/api/posts/${id}`),
  create: (data: any) => apiRequest<any>('/api/posts', {
    method: 'POST',
    body: JSON.stringify(data),
  }),
  update: (id: string, data: any) => apiRequest<any>(`/api/posts/${id}`, {
    method: 'PUT',
    body: JSON.stringify(data),
  }),
  delete: (id: string) => apiRequest<any>(`/api/posts/${id}`, {
    method: 'DELETE',
  }),
};

// TODO: Add proper error handling and retry logic
// TODO: Add request/response interceptors
// TODO: Add loading states management
