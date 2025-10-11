package com.yornest.i_messages.api.response

import kotlinx.serialization.Serializable

/**
 * API response model for messages
 * Matches the pattern used in the main YorNest app
 */
@Serializable
data class MessagesResponse(
    val messages: List<MessageResponse>
)

@Serializable
data class MessageResponse(
    val id: String,
    val sender: String,
    val text: String,
    val timestamp: Long
)
