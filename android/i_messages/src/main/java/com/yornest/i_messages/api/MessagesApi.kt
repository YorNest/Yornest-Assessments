package com.yornest.i_messages.api

import com.yornest.i_messages.api.response.MessagesResponse
import retrofit2.http.GET

/**
 * API interface for messages
 * Matches the pattern used in the main YorNest app
 */
interface MessagesApi {
    
    @GET("api/messages")
    suspend fun getMessages(): MessagesResponse
}
