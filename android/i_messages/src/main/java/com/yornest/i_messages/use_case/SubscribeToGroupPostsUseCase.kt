package com.yornest.i_messages.use_case

import com.yornest.core_base.coroutines.RequestResult
import com.yornest.i_messages.data.GroupPostChangesInfo
import com.yornest.i_messages.repository.MessagesRepository
import com.yornest.network.use_case.OneInputFlowResultUseCase
import kotlinx.coroutines.flow.Flow

/**
 * Use case for subscribing to group posts changes via WebSocket
 */
class SubscribeToGroupPostsUseCase(
    private val repository: MessagesRepository
) : OneInputFlowResultUseCase<SubscribeToGroupPostsUseCase.Params, List<GroupPostChangesInfo>>() {

    override suspend fun invoke(
        input: Params
    ): Flow<RequestResult<List<GroupPostChangesInfo>>> = repository.subscribeToGroupPostsChanges(
        userId = input.userId,
        groupId = input.groupId
    )

    class Params(
        val userId: String,
        val groupId: String
    )
}
