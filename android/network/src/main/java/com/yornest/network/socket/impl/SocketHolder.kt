package com.yornest.network.socket.impl

import okhttp3.WebSocket

class SocketHolder {

    private var webSocket: WebSocket? = null

    fun set(socket: WebSocket) {
        webSocket = socket
    }

    fun release() {
        webSocket = null
    }

    fun actionSafe(action: WebSocket.() -> Unit) {
        val socket = webSocket ?: return
        socket.action()
    }
}
