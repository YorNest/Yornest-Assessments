package com.yornest.i_messages.api.response

import com.yornest.domain.message.MessageInfo
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class MessageResponseObj(
    val id: String,
    val userId: String,
    val contentText: String,
    val memberFullName: String,
    val createdAt: Long,
    val type: String
) {
    fun transform(): MessageInfo {
        return MessageInfo(
            id = id,
            sender = memberFullName,
            text = contentText,
            timestamp = createdAt
        )
    }
}
