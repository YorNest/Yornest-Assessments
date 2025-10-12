package com.yornest.network.socket.api.data

import kotlinx.serialization.KSerializer
import kotlin.reflect.KClass

data class SubscribeResponseTypeWrapper<Response : Any>(
    val responseType: KClass<Response>?,
    val serializer: KSerializer<Response>?
)
