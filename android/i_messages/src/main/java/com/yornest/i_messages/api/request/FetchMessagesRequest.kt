package com.yornest.i_messages.api.request

import kotlinx.serialization.Serializable

/**
 * Request model for creating a simple message
 * Matches the pattern used in the main YorNest app
 */
@Serializable
data class FetchMessagesRequest(
    val userId: String,
    val channelId: String,
    val groupId: String,
    val limit: Int,
    val offset: Int,
)
