package com.yornest.i_messages.repository

import com.yornest.core_base.coroutines.RequestResult
import com.yornest.domain.message.MessagesListInfo
import com.yornest.network.use_case.request.RequestData
import com.yornest.network.use_case.request.RequestType
import kotlinx.coroutines.flow.Flow

/**
 * Repository interface for messages
 * Matches the pattern used in the main YorNest app
 */
interface MessagesRepository {
    
    suspend fun loadMessages(
        requestType: RequestType
    ): Flow<RequestResult<RequestData<MessagesListInfo>>>
}
