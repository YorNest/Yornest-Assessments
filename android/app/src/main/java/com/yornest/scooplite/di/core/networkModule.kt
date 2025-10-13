package com.yornest.scooplite.di.core

import com.jakewharton.retrofit2.converter.kotlinx.serialization.asConverterFactory
import com.yornest.scooplite.BuildConfig
import com.yornest.i_messages.api.MessagesApi
import com.yornest.network.result_handler.RequestResultHandler
import com.yornest.network.result_handler.RequestResultHandlerImpl
import com.yornest.network.socket.api.SocketConnectionManager
import com.yornest.network.socket.api.SocketManager
import com.yornest.network.socket.api.SocketReconnectHandler
import com.yornest.network.socket.impl.DefaultSocketConnectionManager
import com.yornest.network.socket.impl.DefaultSocketManager
import com.yornest.network.socket.impl.DefaultSocketReconnectHandler
import com.yornest.network.socket.SocketProcessLifecycleListenerDelegate
import com.yornest.core_base.lifecycle.process.ProcessLifecycleListenerDelegate
import kotlinx.serialization.ExperimentalSerializationApi
import kotlinx.serialization.json.Json
import org.koin.core.qualifier.named
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import org.koin.dsl.module
import retrofit2.Retrofit

const val SOCKET_PROCESS_LISTENER = "socket_process_listener"

/**
 * Network module that matches the pattern used in the main YorNest app
 */
@OptIn(ExperimentalSerializationApi::class)
val networkModule = module {

    single {
        Json {
            ignoreUnknownKeys = true
            isLenient = true
            explicitNulls = false
            encodeDefaults = true
        }
    }

    single<RequestResultHandler> { RequestResultHandlerImpl() }

    single {
        HttpLoggingInterceptor().apply {
            level = if (BuildConfig.DEBUG) {
                HttpLoggingInterceptor.Level.BODY
            } else {
                HttpLoggingInterceptor.Level.NONE
            }
        }
    }

    single {
        OkHttpClient.Builder()
            .addInterceptor(get<HttpLoggingInterceptor>())
            .build()
    }

    single {
        Retrofit.Builder()
            .baseUrl(BuildConfig.BASE_API_URL)
            .client(get())
            .addConverterFactory(get<Json>().asConverterFactory("application/json".toMediaType()))
            .build()
    }

    single { get<Retrofit>().create(MessagesApi::class.java) }

    // WebSocket components
    single<SocketReconnectHandler> { DefaultSocketReconnectHandler() }

    single<SocketConnectionManager> {
        DefaultSocketConnectionManager(
            okHttpClient = get<OkHttpClient>(),
            socketUrl = BuildConfig.WEBSOCKET_URL
        )
    }

    single<SocketManager> {
        DefaultSocketManager(
            json = get(),
            socketConnectionManager = get(),
            socketReconnectHandler = get()
        )
    }

    single<ProcessLifecycleListenerDelegate>(named(SOCKET_PROCESS_LISTENER)) {
        SocketProcessLifecycleListenerDelegate(get())
    }
}
