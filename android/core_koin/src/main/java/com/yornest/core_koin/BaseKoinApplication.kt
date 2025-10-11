package com.yornest.core_koin

import androidx.multidex.MultiDexApplication

/**
 * Base Koin application class
 * Matches the pattern used in the main YorNest app
 */
abstract class BaseKoinApplication : MultiDexApplication() {

    override fun onCreate() {
        super.onCreate()
        initKoin()
    }

    abstract fun initKoin()
}
