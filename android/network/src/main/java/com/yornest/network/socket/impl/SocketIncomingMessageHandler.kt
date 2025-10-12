package com.yornest.network.socket.impl

import com.yornest.logger.AppLogger
import com.yornest.network.ChangesType
import com.yornest.network.socket.impl.data.SocketMessageData
import kotlinx.serialization.InternalSerializationApi
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import kotlinx.serialization.decodeFromString
import kotlinx.serialization.json.Json
import kotlinx.serialization.json.JsonElement
import kotlinx.serialization.json.JsonNull
import kotlinx.serialization.serializer

class SocketIncomingMessageHandler(
    private val json: Json,
    private val socketSubscriptionsHolder: SocketSubscriptionsHolder
) {

    @OptIn(InternalSerializationApi::class)
    suspend fun handle(message: String) {
        try {
            AppLogger.logD("new message: $message")
            val response = json.decodeFromString<SocketBaseMessageResponse>(message)
            val subscriptionsForTopic = socketSubscriptionsHolder.findByTopic(response.topic)
            subscriptionsForTopic.forEach { subscription ->
                val responseType = subscription.responseType
                val data = when {
                    response.data is JsonNull -> null
                    responseType.responseType != null -> json.decodeFromJsonElement(
                        responseType.responseType.serializer(),
                        response.data
                    )
                    responseType.serializer != null -> json.decodeFromJsonElement(
                        responseType.serializer,
                        response.data
                    )
                    else -> throw RuntimeException("responseType and serializer are null")
                }
                subscription.channel.emit(
                    SocketMessageData(
                        data,
                        ChangesType.fromName(response.eventType ?: "")
                    )
                )
            }
        } catch (ex: Throwable) {
            AppLogger.logE(
                "not able to parse socket response: $message, error: ${ex.localizedMessage}"
            )
        }
    }
}

@Serializable
private class SocketBaseMessageResponse(
    @SerialName("topic")
    val topic: String,
    @SerialName("eventType")
    val eventType: String?,
    @SerialName("data")
    val data: JsonElement,
)
