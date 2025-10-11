package com.yornest.network.use_case.request

/**
 * Wrapper for request data with metadata
 * Matches the pattern used in the main YorNest app
 */
data class RequestData<T>(
    val data: T,
    val isFromCache: Boolean = false,
    val timestamp: Long = System.currentTimeMillis()
)
