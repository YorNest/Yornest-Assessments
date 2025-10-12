package com.yornest.network.socket.impl

import com.yornest.logger.AppLogger
import com.yornest.network.socket.api.SocketConnectionManager
import com.yornest.network.socket.api.SocketManager
import com.yornest.network.socket.api.SocketReconnectHandler
import com.yornest.network.socket.api.SocketState
import com.yornest.network.socket.api.data.SocketMessageRequestWrapper
import com.yornest.network.socket.api.data.SocketResponse
import com.yornest.network.socket.api.data.SocketSubscribeMessageRequest
import com.yornest.network.socket.api.data.SocketUnsubscribeMessageRequest
import com.yornest.network.socket.api.data.SubscribeResponseTypeWrapper
import com.yornest.network.socket.impl.data.SocketManagerInternalEvent
import com.yornest.network.socket.impl.listener_event.SocketEventsListener
import com.yornest.network.socket.impl.listener_event.SocketListenerEvent
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.asCoroutineDispatcher
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.channels.Channel.Factory.BUFFERED
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.flow.receiveAsFlow
import kotlinx.coroutines.launch
import kotlinx.serialization.json.Json
import java.util.concurrent.Executors
import kotlin.coroutines.CoroutineContext
import kotlin.reflect.KClass

class DefaultSocketManager(
    json: Json,
    private val socketConnectionManager: SocketConnectionManager,
    private val socketReconnectHandler: SocketReconnectHandler,
) : SocketManager,
    CoroutineScope {

    private val parentJob = SupervisorJob()

    private val dispatcher = Executors.newSingleThreadExecutor().asCoroutineDispatcher()

    private val socketEventsListener = SocketEventsListener()
    private val stateHolder = SocketStateHolder()
    private val socketHolder = SocketHolder()
    private val socketSubscriptionsHolder = SocketSubscriptionsHolder(
        socketHolder,
        json
    )
    private val socketIncomingMessageHandler = SocketIncomingMessageHandler(
        json,
        socketSubscriptionsHolder
    )

    private val internalEventsChannel = Channel<SocketManagerInternalEvent>(
        capacity = BUFFERED
    )

    override val coroutineContext: CoroutineContext = dispatcher + parentJob

    init {
        launch {
            socketEventsListener
                .eventsFlow
                .collect {
                    handleSocketListenerEvent(it)
                }
        }
        launch {
            internalEventsChannel
                .receiveAsFlow()
                .collect {
                    handleSocketInternalEvent(it)
                }
        }
    }

    override fun connect() {
        AppLogger.logD("connect: ${stateHolder.canConnect}")
        if (stateHolder.canConnect.not()) {
            return
        }
        internalEventsChannel.trySend(SocketManagerInternalEvent.Connect)
    }

    override fun disconnect() {
        AppLogger.logD("disconnect")
        internalEventsChannel.trySend(SocketManagerInternalEvent.Disconnect)
    }

    override suspend fun <Response : Any> subscribeNotNull(
        request: SocketMessageRequestWrapper,
        responseType: KClass<Response>
    ): Flow<SocketResponse<Response>> = subscribe(
        request,
        SubscribeResponseTypeWrapper(
            responseType,
            null
        )
    ).map {
        SocketResponse(
            it.data!!,
            it.changesType
        )
    }

    override suspend fun <Response : Any> subscribeNullable(
        request: SocketMessageRequestWrapper,
        responseType: KClass<Response>
    ): Flow<SocketResponse<Response?>> = subscribe(
        request,
        SubscribeResponseTypeWrapper(
            responseType,
            null
        )
    )

    @Suppress("UNCHECKED_CAST")
    override suspend fun <Response : Any> subscribe(
        request: SocketMessageRequestWrapper,
        wrapper: SubscribeResponseTypeWrapper<Response>
    ): Flow<SocketResponse<Response?>> {
        val requestType = request.subRequest::class as KClass<SocketSubscribeMessageRequest>
        val flow = socketSubscriptionsHolder.add(
            request.subRequest,
            requestType,
            wrapper
        )
        return flow.map {
            val dataMapped = try {
                it.data as? Response?
            } catch (_: Throwable) {
                null
            }
            SocketResponse(
                dataMapped,
                it.changesType
            )
        }
    }

    @Suppress("UNCHECKED_CAST")
    override fun unsubscribe(request: SocketMessageRequestWrapper) {
        val requestType = request.unsubRequest::class as KClass<SocketUnsubscribeMessageRequest>
        launch {
            socketSubscriptionsHolder.remove(
                request,
                requestType
            )
        }
    }

    private suspend fun handleSocketListenerEvent(event: SocketListenerEvent) {
        when (event) {
            is SocketListenerEvent.Opened -> {
                AppLogger.logD("socket opened")
                stateHolder.update(SocketState.Connected)
                socketReconnectHandler.onConnected()
                socketSubscriptionsHolder.onSocketConnected()
            }
            is SocketListenerEvent.Closing -> {
                AppLogger.logD("socket closing")
                stateHolder.update(SocketState.Closing)
            }
            is SocketListenerEvent.Closed -> {
                AppLogger.logD("socket closed")
                stateHolder.update(SocketState.Closed)
                socketHolder.release()
                socketSubscriptionsHolder.onSocketDisconnected()
            }
            is SocketListenerEvent.Failed -> {
                AppLogger.logE("socket failed", event.error)
                stateHolder.update(SocketState.Error(event.error))
                socketHolder.release()
                socketSubscriptionsHolder.onSocketDisconnected()
                socketReconnectHandler.start(this) {
                    internalEventsChannel.trySend(SocketManagerInternalEvent.Reconnect)
                }
            }
            is SocketListenerEvent.NewMessage -> {
                socketIncomingMessageHandler.handle(event.message)
            }
        }
    }

    private fun handleSocketInternalEvent(event: SocketManagerInternalEvent) {
        when (event) {
            is SocketManagerInternalEvent.Connect,
            is SocketManagerInternalEvent.Reconnect -> {
                AppLogger.logD("connecting to socket")
                stateHolder.update(SocketState.Connecting)
                val socket = socketConnectionManager.connect(socketEventsListener.socketListener)
                socketHolder.set(socket)
            }
            is SocketManagerInternalEvent.Disconnect -> {
                AppLogger.logD("disconnecting from socket")
                socketReconnectHandler.cancel()
                socketHolder.actionSafe {
                    close(1000, "Manual disconnect")
                }
            }
        }
    }
}
