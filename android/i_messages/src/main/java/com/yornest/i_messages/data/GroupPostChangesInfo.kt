package com.yornest.i_messages.data

import com.yornest.domain.message.MessageInfo
import com.yornest.network.ChangesType

data class GroupPostChangesInfo(
    val message: MessageInfo,
    val changeType: ChangesType
)
