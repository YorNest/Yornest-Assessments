package com.yornest.scooplite.di.core

import com.yornest.core_base.lifecycle.process.ProcessLifecycleListener
import com.yornest.core_base.lifecycle.process.ProcessLifecycleListenerDelegate
import org.koin.core.qualifier.named
import org.koin.dsl.module

private val processLifecycleDelegatesNames = listOf(
    SOCKET_PROCESS_LISTENER,
)

/**
 * App common module that matches the pattern used in the main YorNest app
 */
val appCommonModule = module {

    single {
        val set = processLifecycleDelegatesNames.map {
            get<ProcessLifecycleListenerDelegate>(named(it))
        }.toSet()
        ProcessLifecycleListener(set)
    }
}
