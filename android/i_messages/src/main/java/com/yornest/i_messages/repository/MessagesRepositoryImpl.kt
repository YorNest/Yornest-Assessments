package com.yornest.i_messages.repository

import com.yornest.core_base.coroutines.RequestResult
import com.yornest.domain.message.MessageInfo
import com.yornest.domain.message.MessagesListInfo
import com.yornest.i_messages.api.MessagesApi
import com.yornest.network.result_handler.RequestResultHandler
import com.yornest.network.use_case.request.RequestData
import com.yornest.network.use_case.request.RequestType
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow

/**
 * Repository implementation for messages
 * Matches the pattern used in the main YorNest app
 */
class MessagesRepositoryImpl(
    private val api: MessagesApi,
    private val requestResultHandler: RequestResultHandler
) : MessagesRepository {
    
    private val cachedMessages = mutableListOf<MessageInfo>()
    
    override suspend fun loadMessages(
        requestType: RequestType
    ): Flow<RequestResult<RequestData<MessagesListInfo>>> = flow {
        
        // Emit cached data first if available and requested
        if (requestType == RequestType.CacheThenRemote && cachedMessages.isNotEmpty()) {
            val cachedData = MessagesListInfo(
                totalCount = cachedMessages.size,
                messages = cachedMessages.toList()
            )
            emit(RequestResult.Success(RequestData(cachedData, isFromCache = true)))
        }
        
        // Load from remote if requested
        if (requestType != RequestType.CacheOnly) {
            val result = requestResultHandler.call {
                // Simulate network delay
                delay(1500)
                
                // Mock data - in real app this would call api.getMessages()
                val mockMessages = listOf(
                    MessageInfo(
                        id = "1",
                        sender = "John Doe",
                        text = "Hello everyone! How's the development going?",
                        timestamp = System.currentTimeMillis() - 3600000
                    ),
                    MessageInfo(
                        id = "2",
                        sender = "Jane Smith",
                        text = "Great! Just finished implementing the new feature.",
                        timestamp = System.currentTimeMillis() - 3000000
                    ),
                    MessageInfo(
                        id = "3",
                        sender = "Mike Johnson",
                        text = "Anyone available for code review?",
                        timestamp = System.currentTimeMillis() - 1800000
                    ),
                    MessageInfo(
                        id = "4",
                        sender = "Sarah Wilson",
                        text = "I can help with that! Send me the PR link.",
                        timestamp = System.currentTimeMillis() - 900000
                    ),
                    MessageInfo(
                        id = "5",
                        sender = "Alex Brown",
                        text = "The new UI looks amazing! 🎉",
                        timestamp = System.currentTimeMillis() - 300000
                    )
                )
                
                // Update cache
                cachedMessages.clear()
                cachedMessages.addAll(mockMessages)
                
                MessagesListInfo(
                    totalCount = mockMessages.size,
                    messages = mockMessages
                )
            }
            
            emit(result.map { RequestData(it, isFromCache = false) })
        }
    }
}
