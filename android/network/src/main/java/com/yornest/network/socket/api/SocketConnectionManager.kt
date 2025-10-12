package com.yornest.network.socket.api

import okhttp3.WebSocket
import okhttp3.WebSocketListener

interface SocketConnectionManager {

    fun connect(listener: WebSocketListener): WebSocket
}
