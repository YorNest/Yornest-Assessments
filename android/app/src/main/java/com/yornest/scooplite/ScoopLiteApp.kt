package com.yornest.scooplite

import androidx.lifecycle.ProcessLifecycleOwner
import com.yornest.scooplite.di.koinModules
import com.yornest.core_koin.BaseKoinApplication
import com.yornest.core_base.lifecycle.process.ProcessLifecycleListener
import org.koin.android.ext.koin.androidContext
import org.koin.android.ext.koin.androidLogger
import org.koin.core.component.KoinComponent
import org.koin.core.component.get
import org.koin.core.context.startKoin
import org.koin.core.logger.Level

/**
 * Application class that matches the pattern used in the main YorNest app
 */
class ScoopLiteApp : BaseKoinApplication(), KoinComponent {

    override fun onCreate() {
        super.onCreate()
        initProcessLifecycleListener()
    }

    override fun initKoin() {
        startKoin {
            if (BuildConfig.DEBUG) {
                androidLogger(Level.ERROR)
            }
            androidContext(applicationContext)
            modules(koinModules)
        }
    }

    private fun initProcessLifecycleListener() {
        val processLifecycleListener = get<ProcessLifecycleListener>()
        ProcessLifecycleOwner.get().lifecycle.addObserver(processLifecycleListener)
    }
}
