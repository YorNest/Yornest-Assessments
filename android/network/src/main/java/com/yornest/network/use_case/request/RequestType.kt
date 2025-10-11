package com.yornest.network.use_case.request

/**
 * Request types for data loading strategy
 * Matches the pattern used in the main YorNest app
 */
enum class RequestType {
    /**
     * Load from cache first, then from remote
     */
    CacheThenRemote,
    
    /**
     * Load only from remote source
     */
    RemoteOnly,
    
    /**
     * Load only from cache
     */
    CacheOnly
}
