package com.yornest.network.socket.api

import com.yornest.network.socket.api.data.SocketMessageRequestWrapper
import com.yornest.network.socket.api.data.SocketResponse
import com.yornest.network.socket.api.data.SubscribeResponseTypeWrapper
import kotlinx.coroutines.flow.Flow
import kotlin.reflect.KClass

interface SocketManager {

    fun connect()

    fun disconnect()

    suspend fun <Response : Any> subscribeNotNull(
        request: SocketMessageRequestWrapper,
        responseType: KClass<Response>
    ): Flow<SocketResponse<Response>>

    suspend fun <Response : Any> subscribeNullable(
        request: SocketMessageRequestWrapper,
        responseType: KClass<Response>
    ): Flow<SocketResponse<Response?>>

    suspend fun <Response : Any> subscribe(
        request: SocketMessageRequestWrapper,
        wrapper: SubscribeResponseTypeWrapper<Response>
    ): Flow<SocketResponse<Response?>>

    fun unsubscribe(
        request: SocketMessageRequestWrapper
    )
}
