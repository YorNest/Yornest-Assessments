package com.yornest.network.socket.impl.data

sealed class SocketManagerInternalEvent {

    object Connect : SocketManagerInternalEvent()

    object Reconnect : SocketManagerInternalEvent()

    object Disconnect : SocketManagerInternalEvent()
}
