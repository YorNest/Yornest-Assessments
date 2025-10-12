package com.yornest.i_messages.api.request

import com.yornest.network.socket.api.data.SocketSubscribeMessageRequest
import com.yornest.network.socket.api.data.SocketUnsubscribeMessageRequest
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class SubscribeToMessagesChangesRequest(
    @SerialName("userId")
    val userId: String,
    @SerialName("channelId")
    val channelId: String? = null,
    @SerialName("topic")
    override val topic: String = "refresh_channel_messages"
): SocketSubscribeMessageRequest()

@Serializable
data class UnsubscribeMessagesChangesRequest(
    @SerialName("userId")
    val userId: String,
    @SerialName("channelId")
    val channelId: String? = null,
    @SerialName("topic")
    override val topic: String = "refresh_channel_messages"
): SocketUnsubscribeMessageRequest()
