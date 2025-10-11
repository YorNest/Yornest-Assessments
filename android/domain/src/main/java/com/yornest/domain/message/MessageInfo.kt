package com.yornest.domain.message

/**
 * Domain model for message information
 * Matches the pattern used in the main YorNest app
 */
data class MessageInfo(
    val id: String,
    val sender: String,
    val text: String,
    val timestamp: Long
)
