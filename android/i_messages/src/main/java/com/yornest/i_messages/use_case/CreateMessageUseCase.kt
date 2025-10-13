package com.yornest.i_messages.use_case

import com.yornest.core_base.coroutines.RequestResult
import com.yornest.domain.message.MessageInfo
import com.yornest.i_messages.repository.MessagesRepository
import com.yornest.network.use_case.OneInputResultUseCase

/**
 * Use case for creating a simple message
 * Matches the pattern used in the main YorNest app
 */
class CreateMessageUseCase(
    private val repository: MessagesRepository
) : OneInputResultUseCase<CreateMessageUseCase.Params, MessageInfo>() {

    override suspend fun invoke(input: Params): RequestResult<MessageInfo> = 
        repository.createMessage(
            userId = input.userId,
            contentText = input.contentText,
            memberFullName = input.memberFullName
        )

    class Params(
        val userId: String,
        val contentText: String,
        val memberFullName: String
    )
}
