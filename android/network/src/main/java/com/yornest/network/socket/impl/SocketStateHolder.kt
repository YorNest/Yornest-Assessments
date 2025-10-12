package com.yornest.network.socket.impl

import com.yornest.network.socket.api.SocketState

class SocketStateHolder {

    private var socketState: SocketState = SocketState.Idle

    val canConnect: Boolean
        get() = socketState is SocketState.Error ||
                socketState is SocketState.Idle ||
                socketState is SocketState.Closed

    fun update(state: SocketState) {
        socketState = state
    }
}
