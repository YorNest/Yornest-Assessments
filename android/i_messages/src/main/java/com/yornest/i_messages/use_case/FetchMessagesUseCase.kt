package com.yornest.i_messages.use_case

import com.yornest.core_base.coroutines.RequestResult
import com.yornest.domain.message.MessagesListInfo
import com.yornest.i_messages.repository.MessagesRepository
import com.yornest.network.use_case.OneInputFlowResultUseCase
import com.yornest.network.use_case.request.RequestData
import com.yornest.network.use_case.request.RequestType
import kotlinx.coroutines.flow.Flow

/**
 * Use case for fetching messages
 * Matches the pattern used in the main YorNest app
 */
class FetchMessagesUseCase(
    private val repository: MessagesRepository
) : OneInputFlowResultUseCase<FetchMessagesUseCase.Params, RequestData<MessagesListInfo>>() {

    override suspend fun invoke(
        input: Params
    ): Flow<RequestResult<RequestData<MessagesListInfo>>> = repository.loadMessages(
        input.requestType,
        userId= "",
        groupId= "",
        channelId= "",
        limit= 0,
        offset= 0
    )

    class Params(
        val requestType: RequestType = RequestType.CacheThenRemote
    )
}
