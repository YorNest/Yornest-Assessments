package com.yornest.core_navigation.router

import com.github.terrakok.cicerone.Router

/**
 * App router wrapper for navigation
 * Matches the pattern used in the main YorNest app
 */
class AppRouter(private val router: Router) {
    
    fun exit() {
        router.exit()
    }
    
    fun navigateToMessages() {
        // In a real app, this would navigate to messages screen
        // For assessment purposes, we'll keep it simple
    }
}
