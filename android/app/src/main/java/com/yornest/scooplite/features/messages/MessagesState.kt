package com.yornest.scooplite.features.messages

import androidx.lifecycle.MutableLiveData
import com.yornest.core_arch.vm.BaseVmState
import com.yornest.domain.message.MessageInfo

/**
 * Messages screen state that matches the pattern used in the main YorNest app
 */
class MessagesState : BaseVmState() {
    val messages = MutableLiveData<List<MessageInfo>>(emptyList())
    val isRefreshing = MutableLiveData<Boolean>(false)

    // Real-time connection state
    val isWebSocketConnected = MutableLiveData<Boolean>(false)
    val connectionStatus = MutableLiveData<String>("Disconnected")

    // Drawer state
    val isDrawerVisible = MutableLiveData<Boolean>(false)
    val inputText = MutableLiveData<String>("")
    val isSubmitting = MutableLiveData<Boolean>(false)

    // Current channel/group info for real-time subscriptions
    val currentUserId = MutableLiveData<String>("")
    val currentChannelId = MutableLiveData<String>("")
    val currentGroupId = MutableLiveData<String>("")
}
