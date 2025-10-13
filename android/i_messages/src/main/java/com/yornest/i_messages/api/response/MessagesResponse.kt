package com.yornest.i_messages.api.response

import kotlinx.serialization.Serializable

/**
 * API response model for messages
 * Matches the pattern used in the main YorNest app
 */
@Serializable
data class FetchMessagesResponse(
    val post: List<MessageResponse>
)

@Serializable
data class MessageResponse(
    val id: String,
    val contentText: String,
    val memberFullName: String,
    val createdAt: Long,
)


