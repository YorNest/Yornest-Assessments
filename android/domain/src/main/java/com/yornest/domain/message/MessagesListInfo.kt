package com.yornest.domain.message

/**
 * Domain model for messages list information
 * Matches the pattern used in the main YorNest app
 */
data class MessagesListInfo(
    val totalCount: Int,
    val messages: List<MessageInfo>
)
