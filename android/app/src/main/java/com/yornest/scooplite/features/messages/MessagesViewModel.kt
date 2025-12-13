package com.yornest.scooplite.features.messages

import androidx.lifecycle.viewModelScope
import com.yornest.core_arch.vm.BaseVm
import com.yornest.core_arch.vm.LoadingState
import com.yornest.core_arch.vm.VmDependencies
import com.yornest.i_messages.use_case.CreateMessageUseCase
import com.yornest.i_messages.use_case.DeleteMessageUseCase
import com.yornest.i_messages.use_case.FetchMessagesUseCase
import com.yornest.i_messages.use_case.SubscribeToGroupPostsUseCase
import com.yornest.network.use_case.request.RequestType
import kotlinx.coroutines.Job
import kotlinx.coroutines.flow.catch
import kotlinx.coroutines.launch

/**
 * Messages ViewModel that matches the pattern used in the main YorNest app
 */
class MessagesViewModel(
    state: MessagesState,
    dependencies: VmDependencies,
    private val fetchMessagesUseCase: FetchMessagesUseCase,
    private val createMessageUseCase: CreateMessageUseCase,
    private val deleteMessageUseCase: DeleteMessageUseCase,
    private val subscribeToGroupPostsUseCase: SubscribeToGroupPostsUseCase
) : BaseVm<MessagesState>(state, dependencies) {

    private var webSocketSubscriptionJob: Job? = null

    companion object {
        private const val CURRENT_USER_ID = "2cef9c34-ee8c-4384-a963-5f875aa71240"
        private const val CURRENT_GROUP_ID = "8ee2da5e-90bf-4770-80b1-76fcd7ee3a7e"
        private const val CURRENT_CHANNEL_ID = "527ab1da-0d28-4d71-95c6-26239c0c909a"
        private const val LIMIT = 10
        private const val OFFSET = 0
    }

    init {
        // Set current channel/group info
        state.currentUserId.postValue(CURRENT_USER_ID)
        state.currentChannelId.postValue(CURRENT_CHANNEL_ID)
        state.currentGroupId.postValue(CURRENT_GROUP_ID)

        loadMessages()
        subscribeToRealTimeUpdates()
    }

    fun loadMessages() {
        viewModelScope.launch {
            state.loading.postValue(LoadingState.Loading)

            fetchMessagesUseCase(
                FetchMessagesUseCase.Params(
                    requestType = RequestType.CacheThenRemote,
                    userId = CURRENT_USER_ID,
                    groupId = CURRENT_GROUP_ID,
                    channelId = CURRENT_CHANNEL_ID,
                    limit = LIMIT,
                    offset = OFFSET
                )
            )
                .catch { error ->
                    runOnUi {
                        state.loading.postValue(LoadingState.Error(error.message ?: "Unknown error"))
                    }
                }
                .collect { result ->
                    result.handleResult { requestData ->
                        state.messages.postValue(requestData.data.messages)
                        state.loading.postValue(LoadingState.None)
                    }
                }
        }
    }

    fun refresh() {
        viewModelScope.launch {
            state.isRefreshing.postValue(true)

            fetchMessagesUseCase(
                FetchMessagesUseCase.Params(
                    requestType = RequestType.RemoteOnly,
                    userId = CURRENT_USER_ID,
                    groupId = CURRENT_GROUP_ID,
                    channelId = CURRENT_CHANNEL_ID,
                    limit = LIMIT,
                    offset = OFFSET
                )
            )
                .catch { error ->
                    runOnUi {
                        state.isRefreshing.postValue(false)
                        dependencies.messageController.showError(error)
                    }
                }
                .collect { result ->
                    result.handleResult { requestData ->
                        state.messages.postValue(requestData.data.messages)
                        state.isRefreshing.postValue(false)
                    }
                }
        }
    }

    // Drawer management
    fun showDrawer() {
        state.isDrawerVisible.postValue(true)
        state.inputText.postValue("")
    }

    fun hideDrawer() {
        state.isDrawerVisible.postValue(false)
        state.inputText.postValue("")
    }

    fun onTextChanged(text: String) {
        state.inputText.postValue(text)
    }

    fun submitMessage() {
        val text = state.inputText.value?.trim()
        if (text.isNullOrBlank()) return

        viewModelScope.launch {
            state.isSubmitting.postValue(true)

            try {
                createMessageUseCase(
                    CreateMessageUseCase.Params(
                        userId = CURRENT_USER_ID,
                        channelId = CURRENT_CHANNEL_ID,
                        groupId = CURRENT_GROUP_ID,
                        contentText = text
                    )
                ).handleResult { messageInfo ->
                    // Success case - message created
                    // Note: Real-time update will come via WebSocket
                    hideDrawer()
                    state.isSubmitting.postValue(false)
                }
            } catch (e: Exception) {
                // Error case
                state.isSubmitting.postValue(false)
                dependencies.messageController.showError(e)
            }
        }
    }

    fun deleteMessage(messageId: String) {
        viewModelScope.launch {
            deleteMessageUseCase(
                DeleteMessageUseCase.Params(
                    messageId = messageId,
                    userId = CURRENT_USER_ID
                )
            ).handleResult { success ->
                if (success) {
                    // Message was deleted successfully
                    loadMessages()
                }
            }
        }
    }

    private fun subscribeToRealTimeUpdates() {
        webSocketSubscriptionJob?.cancel()

        webSocketSubscriptionJob = viewModelScope.launch {
            state.connectionStatus.postValue("Connecting...")

            subscribeToGroupPostsUseCase(
                SubscribeToGroupPostsUseCase.Params(
                    userId = CURRENT_USER_ID,
                    groupId = CURRENT_GROUP_ID
                )
            )
            .catch { error ->
                runOnUi {
                    state.isWebSocketConnected.postValue(false)
                    state.connectionStatus.postValue("Connection Error")
                    dependencies.messageController.showError(error)
                }
            }
            .collect { result ->
                result.handleResult { groupPostChanges ->
                    // Real-time message received
                    state.isWebSocketConnected.postValue(true)
                    state.connectionStatus.postValue("Connected")

                    groupPostChanges.forEach { change ->
                        // Add new message to the list
                        val currentMessages = state.messages.value ?: emptyList()
                        val updatedMessages = listOf(change.message) + currentMessages
                        state.messages.postValue(updatedMessages)
                    }
                }
            }
        }
    }

    fun reconnectWebSocket() {
        subscribeToRealTimeUpdates()
    }

    override fun onCleared() {
        super.onCleared()
        webSocketSubscriptionJob?.cancel()
    }
}
