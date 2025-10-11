package com.yornest.assessment.features.messages

import androidx.lifecycle.viewModelScope
import com.yornest.core_arch.vm.BaseVm
import com.yornest.core_arch.vm.LoadingState
import com.yornest.core_arch.vm.VmDependencies
import com.yornest.i_messages.use_case.FetchMessagesUseCase
import com.yornest.network.use_case.request.RequestType
import kotlinx.coroutines.flow.catch
import kotlinx.coroutines.launch

/**
 * Messages ViewModel that matches the pattern used in the main YorNest app
 */
class MessagesViewModel(
    state: MessagesState,
    dependencies: VmDependencies,
    private val fetchMessagesUseCase: FetchMessagesUseCase
) : BaseVm<MessagesState>(state, dependencies) {

    init {
        loadMessages()
    }

    fun loadMessages() {
        viewModelScope.launch {
            state.loading.postValue(LoadingState.Loading)
            
            fetchMessagesUseCase(FetchMessagesUseCase.Params(RequestType.CacheThenRemote))
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
            
            fetchMessagesUseCase(FetchMessagesUseCase.Params(RequestType.RemoteOnly))
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
}
