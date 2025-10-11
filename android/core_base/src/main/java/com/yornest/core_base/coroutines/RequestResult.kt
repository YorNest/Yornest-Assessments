package com.yornest.core_base.coroutines

/**
 * A generic wrapper for handling request results
 * Matches the pattern used in the main YorNest app
 */
sealed class RequestResult<out T> {
    data class Success<T>(val data: T) : RequestResult<T>()
    data class Error(val error: Throwable) : RequestResult<Nothing>()

    inline fun <R> map(transform: (T) -> R): RequestResult<R> {
        return when (this) {
            is Success -> Success(transform(data))
            is Error -> this
        }
    }

    inline fun onSuccess(action: (T) -> Unit): RequestResult<T> {
        if (this is Success) action(data)
        return this
    }

    inline fun onFailure(action: (Throwable) -> Unit): RequestResult<T> {
        if (this is Error) action(error)
        return this
    }

    fun getOrNull(): T? = when (this) {
        is Success -> data
        is Error -> null
    }

    fun getOrThrow(): T = when (this) {
        is Success -> data
        is Error -> throw error
    }
}
