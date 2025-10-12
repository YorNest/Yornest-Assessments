package com.yornest.scooplite.di.interactors

import com.yornest.i_messages.repository.MessagesRepository
import com.yornest.i_messages.repository.MessagesRepositoryImpl
import com.yornest.i_messages.use_case.FetchMessagesUseCase
import org.koin.dsl.module

/**
 * Messages interactor module that matches the pattern used in the main YorNest app
 */
val messagesInteractorModule = module {

    // Repository
    single<MessagesRepository> {
        MessagesRepositoryImpl(
            api = get(),
            requestResultHandler = get(),
            socketManager = get()
        )
    }

    // Use Cases
    factory {
        FetchMessagesUseCase(
            repository = get()
        )
    }
}
