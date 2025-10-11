package com.yornest.core_koin.di

import com.yornest.core_base.coroutines.DefaultDispatchersProvider
import com.yornest.core_base.coroutines.DispatchersProvider
import com.yornest.core_base.message.DefaultMessageController
import com.yornest.core_base.message.MessageController
import org.koin.dsl.module

/**
 * Application module for core dependencies
 * Matches the pattern used in the main YorNest app
 */
val applicationModule = module {
    single<DispatchersProvider> { DefaultDispatchersProvider() }
    single<MessageController> { DefaultMessageController() }
}
