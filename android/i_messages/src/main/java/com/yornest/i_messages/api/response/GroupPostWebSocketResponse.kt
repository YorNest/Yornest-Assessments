package com.yornest.i_messages.api.response

import com.yornest.domain.message.MessageInfo
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class GroupPostWebSocketResponse(
    val topic: String,
    val sqlFuncName: String,
    val sqlFuncLayer: String,
    val skipProcessing: Boolean,
    val eventType: String,
    val action: String,
    val data: PostResponse
) {
    fun transformToMessageInfo(): MessageInfo {
        // Extract the actual message content from nested posts
        val actualMessage = data.posts?.firstOrNull() ?: return MessageInfo(
            id = data.id,
            sender = data.memberFullName,
            text = data.contentText,
            timestamp = data.createdAt
        )
        
        return MessageInfo(
            id = actualMessage.id,
            sender = actualMessage.memberFullName,
            text = actualMessage.contentText,
            timestamp = actualMessage.createdAt
        )
    }
}
