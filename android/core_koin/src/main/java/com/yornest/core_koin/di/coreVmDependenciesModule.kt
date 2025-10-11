package com.yornest.core_koin.di

import com.yornest.core_arch.vm.VmDependencies
import org.koin.dsl.module

/**
 * Core ViewModel dependencies module
 * Matches the pattern used in the main YorNest app
 */
val coreVmDependenciesModule = module {
    factory {
        VmDependencies(
            ciceroneHolder = get(),
            router = get(),
            messageController = get(),
            dispatchers = get()
        )
    }
}
