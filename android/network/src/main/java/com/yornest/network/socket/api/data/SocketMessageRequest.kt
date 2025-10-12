package com.yornest.network.socket.api.data

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

interface SocketMessageRequest {

    val topic: String

    val action: String
}

@Serializable
abstract class SocketSubscribeMessageRequest : SocketMessageRequest {

    @SerialName("action")
    override val action: String = "subscribe"
}

@Serializable
abstract class SocketUnsubscribeMessageRequest : SocketMessageRequest {

    @SerialName("action")
    override val action: String = "unsubscribe"
}

data class SocketMessageRequestWrapper(
    val subRequest: SocketSubscribeMessageRequest,
    val unsubRequest: SocketUnsubscribeMessageRequest,
)
