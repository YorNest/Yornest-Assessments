package com.yornest.assessment

import com.yornest.assessment.di.koinModules
import com.yornest.core_koin.BaseKoinApplication
import org.koin.android.ext.koin.androidContext
import org.koin.android.ext.koin.androidLogger
import org.koin.core.context.startKoin
import org.koin.core.logger.Level

/**
 * Application class that matches the pattern used in the main YorNest app
 */
class AssessmentApp : BaseKoinApplication() {

    override fun initKoin() {
        startKoin {
            if (BuildConfig.DEBUG) {
                androidLogger(Level.ERROR)
            }
            androidContext(applicationContext)
            modules(koinModules)
        }
    }
}
