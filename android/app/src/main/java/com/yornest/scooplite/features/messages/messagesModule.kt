package com.yornest.scooplite.features.messages

import com.yornest.i_messages.use_case.SubscribeToGroupPostsUseCase
import org.koin.androidx.viewmodel.dsl.viewModel
import org.koin.dsl.module

/**
 * Messages feature module that matches the pattern used in the main YorNest app
 */
val messagesModule = module {

    // Use cases
    factory { SubscribeToGroupPostsUseCase(get()) }

    viewModel {
        MessagesViewModel(
            state = MessagesState(),
            dependencies = get(),
            fetchMessagesUseCase = get(),
            createMessageUseCase = get(),
            deleteMessageUseCase = get(),
            subscribeToGroupPostsUseCase = get()
        )
    }
}
