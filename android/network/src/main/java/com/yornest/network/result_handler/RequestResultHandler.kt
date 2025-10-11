package com.yornest.network.result_handler

import com.yornest.core_base.coroutines.RequestResult
import kotlinx.coroutines.CoroutineDispatcher

interface RequestResultHandler {

    suspend fun <R : Any> call(
        action: suspend () -> R
    ): RequestResult<R>

    suspend fun <R : Any> call(
        dispatcher: CoroutineDispatcher,
        action: suspend () -> R
    ): RequestResult<R>
}

class RequestResultHandlerImpl : RequestResultHandler {
    
    override suspend fun <R : Any> call(
        action: suspend () -> R
    ): RequestResult<R> {
        return try {
            RequestResult.Success(action())
        } catch (e: Exception) {
            RequestResult.Error(e)
        }
    }

    override suspend fun <R : Any> call(
        dispatcher: CoroutineDispatcher,
        action: suspend () -> R
    ): RequestResult<R> {
        return try {
            RequestResult.Success(action())
        } catch (e: Exception) {
            RequestResult.Error(e)
        }
    }
}
