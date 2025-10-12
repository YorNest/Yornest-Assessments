package com.yornest.network.socket.impl

import com.yornest.network.socket.api.SocketConnectionManager
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.WebSocket
import okhttp3.WebSocketListener

class DefaultSocketConnectionManager(
    private val okHttpClient: OkHttpClient,
    private val socketUrl: String
) : SocketConnectionManager {

    override fun connect(listener: WebSocketListener): WebSocket {
        val request = Request.Builder()
            .url(socketUrl)
            .build()
        return okHttpClient.newWebSocket(request, listener)
    }
}
