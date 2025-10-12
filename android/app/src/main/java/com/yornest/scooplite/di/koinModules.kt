package com.yornest.scooplite.di

import com.yornest.scooplite.di.core.appCommonModule
import com.yornest.scooplite.di.core.networkModule
import com.yornest.scooplite.di.interactors.messagesInteractorModule
import com.yornest.scooplite.features.messages.messagesModule
import com.yornest.core_koin.di.applicationModule
import com.yornest.core_koin.di.coreVmDependenciesModule
import com.yornest.core_koin.di.navigationModule
import org.koin.core.module.Module

/**
 * Koin modules configuration that matches the pattern used in the main YorNest app
 */

private val featureModules: List<Module> = listOf(
    messagesModule,
)

private val coreModules: List<Module> = listOf(
    applicationModule,
    navigationModule,
    coreVmDependenciesModule,
    networkModule,
    appCommonModule,
)

private val interactorsModules: List<Module> = listOf(
    messagesInteractorModule,
)

val koinModules: List<Module> = coreModules + interactorsModules + featureModules
