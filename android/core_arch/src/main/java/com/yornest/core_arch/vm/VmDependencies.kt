package com.yornest.core_arch.vm

import com.yornest.core_base.coroutines.DispatchersProvider
import com.yornest.core_base.message.MessageController
import com.yornest.core_navigation.CiceroneHolder
import com.yornest.core_navigation.router.AppRouter

/**
 * Dependencies required by ViewModels
 * Matches the pattern used in the main YorNest app
 */
data class VmDependencies(
    val ciceroneHolder: CiceroneHolder,
    val router: AppRouter,
    val messageController: MessageController,
    val dispatchers: DispatchersProvider,
)
