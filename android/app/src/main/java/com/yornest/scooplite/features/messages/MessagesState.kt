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

    // Drawer state
    val isDrawerVisible = MutableLiveData<Boolean>(false)
    val inputText = MutableLiveData<String>("")
    val isSubmitting = MutableLiveData<Boolean>(false)
}
