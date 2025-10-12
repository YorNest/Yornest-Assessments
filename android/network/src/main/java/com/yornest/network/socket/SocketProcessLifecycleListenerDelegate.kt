package com.yornest.network.socket

import androidx.lifecycle.LifecycleOwner
import com.yornest.core_base.lifecycle.process.ProcessLifecycleListenerDelegate
import com.yornest.network.socket.api.SocketManager

class SocketProcessLifecycleListenerDelegate(
    private val socketManager: SocketManager,
) : ProcessLifecycleListenerDelegate {

    override fun onCreate(owner: LifecycleOwner) {
        socketManager.connect()
    }

    override fun onStart(owner: LifecycleOwner) {
        socketManager.connect()
    }

    override fun onStop(owner: LifecycleOwner) {
        socketManager.disconnect()
    }
}
