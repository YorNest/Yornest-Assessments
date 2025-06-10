import { create } from 'zustand';
import { UserStore, User } from '@/types';
import { mockUsers, currentUser } from '@/utils/mockData';

export const useUserStore = create<UserStore>((set, get) => ({
  currentUser: currentUser,
  users: [...mockUsers],
  loading: false,
  error: null,

  setCurrentUser: (user: User) => {
    set({ currentUser: user });
  },

  fetchUsers: async () => {
    set({ loading: true, error: null });
    
    try {
      // Simulate API call
      await new Promise(resolve => setTimeout(resolve, 500));
      set({ users: [...mockUsers], loading: false });
    } catch (error) {
      set({ 
        error: error instanceof Error ? error.message : 'Failed to fetch users',
        loading: false 
      });
    }
  },

  clearError: () => {
    set({ error: null });
  },
}));
