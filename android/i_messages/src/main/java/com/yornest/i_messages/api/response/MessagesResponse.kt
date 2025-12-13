package com.yornest.i_messages.api.response

import kotlinx.serialization.Serializable

/**
 * API response model for messages
 * Updated to match the actual API structure with nested posts
 */
@Serializable
data class FetchMessagesResponse(
    val result: String,
    val message: String,
    val offset: Int,
    val post: List<PostResponse>
)

@Serializable
data class CreateMessageResponse(
    val result: String,
    val message: String,
    val post: PostResponse
)

@Serializable
data class PostResponse(
    val id: String,
    val clientId: String,
    val threadId: String,
    val channelId: String,
    val userId: String,
    val groupId: String,
    val type: String,
    val memberFirstName: String,
    val memberFullName: String,
    val memberUsername: String,
    val memberProfileImage: String,
    val userReaction: String? = null,
    val isLatestReaction: String? = null,
    val contentText: String,
    val category: String,
    val contentUrls: String? = null,
    val contents: String? = null,
    val seenCount: Int,
    val unseenRepliesCount: Int,
    val totalRepliesCount: Int,
    val likesCount: Int,
    val reactionsCount: Int,
    val tags: List<String>? = null,
    val hashtags: List<String>? = null,
    val winner: String? = null,
    val thumbnailUrl: String? = null,
    val optionIdUserVoted: String? = null,
    val hasEnded: Boolean? = null,
    val isPublic: Boolean? = null,
    val asNestProfile: String? = null,
    val hasLiked: Boolean,
    val hasDisliked: Boolean,
    val hasBeenEdited: Boolean,
    val hasRead: Boolean,
    val hasBookmarked: Boolean,
    val isPinned: Boolean,
    val isPremium: Boolean,
    val pollDuration: Long? = null,
    val videoDuration: Long? = null,
    val shareLink: String,
    val channelType: String,
    val index: Int,
    val options: String? = null,
    val recentProfileImages: List<String>? = null,
    val recentPollProfileImages: List<String>? = null,
    val recentReactions: List<String>? = null,
    val posts: List<PostResponse>? = null,
    val actionOptions: List<String>,
    val createdAt: Long,
    val bookmarkedAt: Long? = null
)

// Legacy support - keeping for backward compatibility
@Serializable
data class MessageResponse(
    val id: String,
    val contentText: String,
    val memberFullName: String,
    val createdAt: Long,
)


