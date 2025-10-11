package com.yornest.scooplite.features.messages

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.DiffUtil
import androidx.recyclerview.widget.ListAdapter
import androidx.recyclerview.widget.RecyclerView
import com.yornest.assessment.databinding.ItemMessageBinding
import com.yornest.domain.message.MessageInfo
import java.text.SimpleDateFormat
import java.util.*

/**
 * Messages adapter that matches the pattern used in the main YorNest app
 */
class MessagesAdapter : ListAdapter<MessageInfo, MessagesAdapter.MessageViewHolder>(MessageDiffCallback()) {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): MessageViewHolder {
        val binding = ItemMessageBinding.inflate(LayoutInflater.from(parent.context), parent, false)
        return MessageViewHolder(binding)
    }

    override fun onBindViewHolder(holder: MessageViewHolder, position: Int) {
        holder.bind(getItem(position))
    }

    class MessageViewHolder(private val binding: ItemMessageBinding) : RecyclerView.ViewHolder(binding.root) {
        
        private val dateFormat = SimpleDateFormat("MMM dd, HH:mm", Locale.getDefault())
        
        fun bind(message: MessageInfo) {
            binding.tvSender.text = message.sender
            binding.tvMessage.text = message.text
            binding.tvTimestamp.text = dateFormat.format(Date(message.timestamp))
        }
    }

    private class MessageDiffCallback : DiffUtil.ItemCallback<MessageInfo>() {
        override fun areItemsTheSame(oldItem: MessageInfo, newItem: MessageInfo): Boolean {
            return oldItem.id == newItem.id
        }

        override fun areContentsTheSame(oldItem: MessageInfo, newItem: MessageInfo): Boolean {
            return oldItem == newItem
        }
    }
}
