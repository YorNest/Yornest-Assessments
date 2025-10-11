package com.yornest.assessment.features.messages

import org.koin.androidx.viewmodel.dsl.viewModel
import org.koin.dsl.module

/**
 * Messages feature module that matches the pattern used in the main YorNest app
 */
val messagesModule = module {
    
    viewModel {
        MessagesViewModel(
            state = MessagesState(),
            dependencies = get(),
            fetchMessagesUseCase = get()
        )
    }
}
