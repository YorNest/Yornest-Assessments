package com.yornest.i_messages.use_case

import com.yornest.core_base.coroutines.RequestResult
import com.yornest.i_messages.repository.MessagesRepository
import com.yornest.network.use_case.OneInputResultUseCase

/**
 * Use case for deleting a simple message
 * Matches the pattern used in the main YorNest app
 */
class DeleteMessageUseCase(
    private val repository: MessagesRepository
) : OneInputResultUseCase<DeleteMessageUseCase.Params, Boolean>() {

    override suspend fun invoke(input: Params): RequestResult<Boolean> = 
        repository.deleteMessage(
            messageId = input.messageId,
            userId = input.userId
        )

    class Params(
        val messageId: String,
        val userId: String
    )
}
