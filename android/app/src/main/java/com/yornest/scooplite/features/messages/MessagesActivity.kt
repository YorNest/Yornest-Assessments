package com.yornest.scooplite.features.messages

import android.os.Bundle
import android.view.View
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.Observer
import androidx.recyclerview.widget.LinearLayoutManager
import com.yornest.assessment.databinding.ActivityMessagesBinding
import com.yornest.core_arch.vm.LoadingState
import org.koin.androidx.viewmodel.ext.android.viewModel

/**
 * Messages activity that matches the pattern used in the main YorNest app
 */
class MessagesActivity : AppCompatActivity() {

    private lateinit var binding: ActivityMessagesBinding
    private val viewModel: MessagesViewModel by viewModel()
    private lateinit var adapter: MessagesAdapter

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMessagesBinding.inflate(layoutInflater)
        setContentView(binding.root)

        setupUI()
        observeViewModel()
    }

    private fun setupUI() {
        setSupportActionBar(binding.toolbar)
        
        adapter = MessagesAdapter()
        binding.recyclerView.layoutManager = LinearLayoutManager(this)
        binding.recyclerView.adapter = adapter

        binding.swipeRefresh.setOnRefreshListener {
            viewModel.refresh()
        }
    }

    private fun observeViewModel() {
        viewModel.state.messages.observe(this, Observer { messages ->
            adapter.submitList(messages)
        })

        viewModel.state.loading.observe(this, Observer { loadingState ->
            when (loadingState) {
                is LoadingState.Loading -> {
                    binding.progressBar.visibility = View.VISIBLE
                    binding.tvError.visibility = View.GONE
                }
                is LoadingState.Error -> {
                    binding.progressBar.visibility = View.GONE
                    binding.tvError.visibility = View.VISIBLE
                    binding.tvError.text = loadingState.message
                }
                is LoadingState.None -> {
                    binding.progressBar.visibility = View.GONE
                    binding.tvError.visibility = View.GONE
                }
            }
        })

        viewModel.state.isRefreshing.observe(this, Observer { isRefreshing ->
            binding.swipeRefresh.isRefreshing = isRefreshing
        })
    }
}
