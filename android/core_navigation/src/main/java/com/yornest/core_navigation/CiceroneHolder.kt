package com.yornest.core_navigation

import com.github.terrakok.cicerone.Cicerone
import com.github.terrakok.cicerone.Router

/**
 * Cicerone holder for navigation management
 * Matches the pattern used in the main YorNest app
 */
class CiceroneHolder {
    private val cicerone = Cicerone.create()
    
    val router: Router get() = cicerone.router
    val navigatorHolder get() = cicerone.getNavigatorHolder()
}
