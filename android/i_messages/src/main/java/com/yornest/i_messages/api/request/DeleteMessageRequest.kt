package com.yornest.i_messages.api.request

import kotlinx.serialization.Serializable

/**
 * Request model for deleting a simple message
 * Matches the pattern used in the main YorNest app
 */
@Serializable
data class DeleteMessageRequest(
    val messageId: String,
    val userId: String
)
