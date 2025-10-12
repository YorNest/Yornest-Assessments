package com.yornest.network.socket.impl

import com.yornest.logger.AppLogger
import com.yornest.network.socket.api.data.SocketMessageRequestWrapper
import com.yornest.network.socket.api.data.SocketSubscribeMessageRequest
import com.yornest.network.socket.api.data.SocketUnsubscribeMessageRequest
import com.yornest.network.socket.api.data.SubscribeResponseTypeWrapper
import com.yornest.network.socket.impl.data.SocketMessageData
import com.yornest.network.socket.impl.data.SocketSubscriptionData
import com.yornest.network.socket.impl.data.SocketSubscriptionState
import com.yornest.network.socket.impl.data.needToResubscribe
import com.yornest.network.socket.impl.data.needToSubscribe
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.sync.Mutex
import kotlinx.coroutines.sync.withLock
import kotlinx.serialization.InternalSerializationApi
import kotlinx.serialization.json.Json
import kotlinx.serialization.serializer
import java.util.concurrent.atomic.AtomicInteger
import kotlin.reflect.KClass

class SocketSubscriptionsHolder(
    private val socketHolder: SocketHolder,
    private val json: Json,
) {

    private val mutex = Mutex()
    private val subscriptions = hashMapOf<SocketSubscribeMessageRequest, SocketSubscriptionData>()

    suspend fun <Request : SocketSubscribeMessageRequest> add(
        request: Request,
        requestType: KClass<Request>,
        responseType: SubscribeResponseTypeWrapper<*>
    ): Flow<SocketMessageData> = mutex.withLock {
        val subscriptionData = subscriptions.getOrPut(request) {
            SocketSubscriptionData(
                responseType,
                MutableSharedFlow(extraBufferCapacity = Int.MAX_VALUE)
            )
        }
        val newData = subscriptionData.copy(
            subscribers = AtomicInteger(subscriptionData.subscribers.incrementAndGet())
        )
        subscriptions[request] = newData
        if (newData.needToSubscribe) {
            subscribeToTopic(request, requestType, newData)
        }
        newData.channel
    }

    suspend fun remove(
        request: SocketMessageRequestWrapper,
        unsubRequestType: KClass<SocketUnsubscribeMessageRequest>,
    ) {
        mutex.withLock {
            val subscription = subscriptions[request.subRequest] ?: return
            val newInfo = subscription.copy(
                subscribers = AtomicInteger(subscription.subscribers.decrementAndGet().coerceAtLeast(0))
            )
            subscriptions[request.subRequest] = newInfo
            if (newInfo.subscribers.get() == 0) {
                subscriptions[request.subRequest] = newInfo.copy(
                    state = SocketSubscriptionState.ToClose
                )
                unsubscribeFromTopic(request, unsubRequestType)
            }
        }
    }

    @Suppress("UNCHECKED_CAST")
    suspend fun onSocketConnected() {
        mutex.withLock {
            subscriptions
                .filter { it.value.needToSubscribe }
                .forEach {
                    subscribeToTopic(
                        it.key,
                        it.key::class as KClass<SocketSubscribeMessageRequest>,
                        it.value
                    )
                }
        }
    }

    @Suppress("UNCHECKED_CAST")
    suspend fun onSocketDisconnected() {
        mutex.withLock {
            subscriptions
                .filter { it.value.needToResubscribe }
                .forEach {
                    subscriptions[it.key] = it.value.copy(
                        state = SocketSubscriptionState.Idle
                    )
                }
        }
    }

    suspend fun findByTopic(
        topic: String
    ): List<SocketSubscriptionData> = mutex.withLock {
        subscriptions
            .filter { it.key.topic == topic }
            .map { it.value }
    }

    @OptIn(InternalSerializationApi::class)
    private fun <Request : SocketSubscribeMessageRequest> subscribeToTopic(
        request: Request,
        requestType: KClass<Request>,
        subscriptionData: SocketSubscriptionData
    ) {
        socketHolder.actionSafe {
            val serializer = requestType.serializer()
            val jsonRequest = json.encodeToString(serializer, request)
            AppLogger.logD("subscribeToTopic: $jsonRequest")
            if (send(jsonRequest)) {
                subscriptions[request] = subscriptionData.copy(
                    state = SocketSubscriptionState.Subscribed
                )
            }
        }
    }

    @OptIn(InternalSerializationApi::class)
    private fun unsubscribeFromTopic(
        request: SocketMessageRequestWrapper,
        unsubRequestType: KClass<SocketUnsubscribeMessageRequest>
    ) {
        socketHolder.actionSafe {
            val serializer = unsubRequestType.serializer()
            val jsonRequest = json.encodeToString(serializer, request.unsubRequest)
            AppLogger.logD("unsubscribeFromTopic: $jsonRequest")
            if (send(jsonRequest)) {
                subscriptions.remove(request.subRequest)
            }
        }
    }
}
