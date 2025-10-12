package com.yornest.network.socket.impl

import com.yornest.network.socket.api.SocketReconnectHandler
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import java.util.concurrent.atomic.AtomicInteger

class DefaultSocketReconnectHandler : SocketReconnectHandler {

    private var reconnectionJob: Job? = null
    private var reconnectCounter = AtomicInteger(0)

    override fun start(
        scope: CoroutineScope,
        action: suspend () -> Unit
    ) {
        cancel()
        reconnectionJob = scope.launch {
            delay(calculateReconnectionDelay())
            action()
        }
    }

    override fun onConnected() {
        reconnectCounter.set(0)
    }

    override fun cancel() {
        reconnectionJob?.cancel()
        reconnectionJob = null
    }

    private fun calculateReconnectionDelay(): Long =
        reconnectCounter.incrementAndGet() * 2_000L
}
