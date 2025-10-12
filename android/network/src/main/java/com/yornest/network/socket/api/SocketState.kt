package com.yornest.network.socket.api

sealed class SocketState {

    //final state
    object Idle : SocketState()

    //while connecting
    object Connecting : SocketState()

    //when connected
    object Connected : SocketState()

    //while closing
    object Closing : SocketState()

    //final state
    object Closed : SocketState()

    //final state
    class Error(
        val error: Throwable
    ) : SocketState()
}
