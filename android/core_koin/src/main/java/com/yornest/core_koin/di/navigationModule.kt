package com.yornest.core_koin.di

import com.yornest.core_navigation.CiceroneHolder
import com.yornest.core_navigation.router.AppRouter
import org.koin.dsl.module

/**
 * Navigation module for Cicerone dependencies
 * Matches the pattern used in the main YorNest app
 */
val navigationModule = module {
    single { CiceroneHolder() }
    single { AppRouter(get<CiceroneHolder>().router) }
}
