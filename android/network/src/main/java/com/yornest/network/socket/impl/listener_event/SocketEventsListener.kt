package com.yornest.network.socket.impl.listener_event

import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.channels.Channel.Factory.UNLIMITED
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.receiveAsFlow
import okhttp3.Response
import okhttp3.WebSocket
import okhttp3.WebSocketListener

class SocketEventsListener {

    private val eventsChannel = Channel<SocketListenerEvent>(
        capacity = UNLIMITED
    )
    private val webSocketListener = object : WebSocketListener() {

        override fun onClosing(webSocket: WebSocket, code: Int, reason: String) {
            sendEvent(
                SocketListenerEvent.Closing(
                    code = code,
                    reason = reason
                )
            )
        }

        override fun onClosed(webSocket: WebSocket, code: Int, reason: String) {
            sendEvent(
                SocketListenerEvent.Closed(
                    code = code,
                    reason = reason
                )
            )
        }

        override fun onFailure(webSocket: WebSocket, t: Throwable, response: Response?) {
            sendEvent(
                SocketListenerEvent.Failed(
                    error = t
                )
            )
        }

        override fun onOpen(webSocket: WebSocket, response: Response) {
            sendEvent(SocketListenerEvent.Opened)
        }

        override fun onMessage(webSocket: WebSocket, text: String) {
            sendEvent(
                SocketListenerEvent.NewMessage(
                    message = text,
                )
            )
        }
    }

    val eventsFlow: Flow<SocketListenerEvent>
        get() = eventsChannel.receiveAsFlow()

    val socketListener: WebSocketListener = webSocketListener

    private fun sendEvent(event: SocketListenerEvent) {
        eventsChannel.trySend(event)
    }
}
