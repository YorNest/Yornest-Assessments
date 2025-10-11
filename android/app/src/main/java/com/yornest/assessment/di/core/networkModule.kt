package com.yornest.assessment.di.core

import com.jakewharton.retrofit2.converter.kotlinx.serialization.asConverterFactory
import com.yornest.assessment.BuildConfig
import com.yornest.i_messages.api.MessagesApi
import com.yornest.network.result_handler.RequestResultHandler
import com.yornest.network.result_handler.RequestResultHandlerImpl
import kotlinx.serialization.json.Json
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import org.koin.dsl.module
import retrofit2.Retrofit

/**
 * Network module that matches the pattern used in the main YorNest app
 */
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
            .baseUrl(BuildConfig.BaseApiUrl)
            .client(get())
            .addConverterFactory(get<Json>().asConverterFactory("application/json".toMediaType()))
            .build()
    }

    single { get<Retrofit>().create(MessagesApi::class.java) }
}
