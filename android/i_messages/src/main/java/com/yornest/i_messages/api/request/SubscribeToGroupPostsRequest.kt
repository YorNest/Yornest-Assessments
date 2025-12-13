package com.yornest.i_messages.api.request

import com.yornest.network.socket.api.data.SocketSubscribeMessageRequest
import com.yornest.network.socket.api.data.SocketUnsubscribeMessageRequest
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class SubscribeToGroupPostsRequest(
    @SerialName("userId")
    val userId: String,
    @SerialName("groupId")
    val groupId: String,
    @SerialName("topic")
    override val topic: String = "refresh_group_posts"
): SocketSubscribeMessageRequest()

@Serializable
data class UnsubscribeGroupPostsRequest(
    @SerialName("userId")
    val userId: String,
    @SerialName("groupId")
    val groupId: String,
    @SerialName("topic")
    override val topic: String = "refresh_group_posts"
): SocketUnsubscribeMessageRequest()
