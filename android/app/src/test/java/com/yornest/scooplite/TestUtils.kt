package com.yornest.scooplite

import com.yornest.domain.message.MessageInfo

/**
 * Test utilities for creating mock data and common test helpers
 * 
 * This follows the testing patterns used in the main YorNest app
 */
object TestUtils {

    /**
     * Creates a sample MessageInfo for testing
     */
    fun createSampleMessage(
        id: String = "test-id",
        text: String = "Test message content",
        sender: String = "Test Author",
        timestamp: Long = System.currentTimeMillis()
    ): MessageInfo {
        return MessageInfo(
            id = id,
            text = text,
            sender = sender,
            timestamp = timestamp
        )
    }

    /**
     * Creates a list of sample messages for testing
     */
    fun createSampleMessages(count: Int = 3): List<MessageInfo> {
        return (1..count).map { index ->
            createSampleMessage(
                id = "test-id-$index",
                text = "Test message content $index",
                sender = "Test Author $index",
                timestamp = System.currentTimeMillis() - (index * 1000)
            )
        }
    }


}
