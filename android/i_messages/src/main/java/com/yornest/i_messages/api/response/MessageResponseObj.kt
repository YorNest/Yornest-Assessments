package com.yornest.i_messages.api.response

import com.yornest.domain.message.MessageInfo
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class MessageResponseObj(
    @SerialName("id")
    val id: String,
    @SerialName("sender")
    val sender: String,
    @SerialName("text")
    val text: String,
    @SerialName("timestamp")
    val timestamp: Long
) {
    fun transform(): MessageInfo {
        return MessageInfo(
            id = id,
            sender = sender,
            text = text,
            timestamp = timestamp
        )
    }
}
