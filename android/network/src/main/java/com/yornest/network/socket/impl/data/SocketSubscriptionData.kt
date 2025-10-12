package com.yornest.network.socket.impl.data

import com.yornest.network.socket.api.data.SubscribeResponseTypeWrapper
import kotlinx.coroutines.flow.MutableSharedFlow
import java.util.concurrent.atomic.AtomicInteger

data class SocketSubscriptionData(
    val responseType: SubscribeResponseTypeWrapper<*>,
    val channel: MutableSharedFlow<SocketMessageData>,
    val subscribers: AtomicInteger = AtomicInteger(0),
    val state: SocketSubscriptionState = SocketSubscriptionState.Idle,
) {

    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (javaClass != other?.javaClass) return false

        other as SocketSubscriptionData

        if (responseType != other.responseType) return false
        if (state != other.state) return false

        return true
    }

    override fun hashCode(): Int {
        var result = responseType.hashCode()
        result = 31 * result + state.hashCode()
        return result
    }
}

val SocketSubscriptionData.needToSubscribe: Boolean
    get() = state == SocketSubscriptionState.Idle

val SocketSubscriptionData.needToResubscribe: Boolean
    get() = state != SocketSubscriptionState.ToClose

enum class SocketSubscriptionState {
    Idle,
    Subscribed,
    ToClose;
}
