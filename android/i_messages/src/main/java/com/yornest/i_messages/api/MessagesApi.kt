package com.yornest.i_messages.api

import com.yornest.i_messages.api.request.CreateMessageRequest
import com.yornest.i_messages.api.request.DeleteMessageRequest
import com.yornest.i_messages.api.request.FetchMessagesRequest
import com.yornest.i_messages.api.response.CreateMessageResponse
import com.yornest.i_messages.api.response.FetchMessagesResponse
import com.yornest.i_messages.api.response.MessageResponse
import retrofit2.http.Body
import retrofit2.http.POST

/**
 * API interface for messages
 */
interface MessagesApi {

    @POST("fetchSimpleMessages")
    suspend fun getMessages(@Body request: FetchMessagesRequest): FetchMessagesResponse

    @POST("createSimpleMessage")
    suspend fun createMessage(@Body request: CreateMessageRequest): CreateMessageResponse

    @POST("deleteSimpleMessage")
    suspend fun deleteMessage(@Body request: DeleteMessageRequest): MessageResponse
}
