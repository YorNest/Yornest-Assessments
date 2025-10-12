package com.yornest.network.socket.impl.listener_event

sealed class SocketListenerEvent {

    object Opened : SocketListenerEvent()

    class Closing(
        val code: Int,
        val reason: String,
    ) : SocketListenerEvent()

    class Closed(
        val code: Int,
        val reason: String,
    ) : SocketListenerEvent()

    class Failed(
        val error: Throwable,
    ) : SocketListenerEvent()

    class NewMessage(
        val message: String,
    ) : SocketListenerEvent()
}
