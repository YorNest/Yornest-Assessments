package com.yornest.i_messages.repository

import com.yornest.core_base.coroutines.RequestResult
import com.yornest.domain.message.MessageInfo
import com.yornest.domain.message.MessagesListInfo
import com.yornest.i_messages.data.MessageChangesInfo
import com.yornest.network.use_case.request.RequestData
import com.yornest.network.use_case.request.RequestType
import kotlinx.coroutines.flow.Flow

/**
 * Repository interface for messages
 * Matches the pattern used in the main YorNest app
 */
interface MessagesRepository {

    suspend fun loadMessages(
        requestType: RequestType,
        userId: String,
        groupId: String,
        channelId: String,
        limit: Int,
        offset: Int
    ): Flow<RequestResult<RequestData<MessagesListInfo>>>

    suspend fun subscribeToMessagesChanges(
        userId: String,
        channelId: String? = null
    ): Flow<RequestResult<List<MessageChangesInfo>>>

    suspend fun createMessage(
        userId: String,
        contentText: String,
        memberFullName: String
    ): RequestResult<MessageInfo>

    suspend fun deleteMessage(
        messageId: String,
        userId: String
    ): RequestResult<Boolean>
}
