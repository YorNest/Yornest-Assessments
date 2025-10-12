package com.yornest.network.socket.api

import kotlinx.coroutines.CoroutineScope

interface SocketReconnectHandler {

    fun start(
        scope: CoroutineScope,
        action: suspend () -> Unit
    )

    fun onConnected()

    fun cancel()
}
