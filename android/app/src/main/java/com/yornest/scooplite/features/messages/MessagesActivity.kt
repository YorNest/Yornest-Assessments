package com.yornest.scooplite.features.messages

import android.os.Bundle
import android.view.View
import androidx.appcompat.app.AppCompatActivity
import androidx.core.widget.doAfterTextChanged
import androidx.recyclerview.widget.LinearLayoutManager
import com.google.android.material.bottomsheet.BottomSheetDialog
import com.yornest.core_arch.vm.LoadingState
import com.yornest.scooplite.R
import com.yornest.scooplite.databinding.ActivityMessagesBinding
import com.yornest.scooplite.databinding.BottomSheetCreateMessageBinding
import org.koin.androidx.viewmodel.ext.android.viewModel

/**
 * Messages activity that matches the pattern used in the main YorNest app
 */
class MessagesActivity : AppCompatActivity() {

    private lateinit var binding: ActivityMessagesBinding
    private val viewModel: MessagesViewModel by viewModel()
    private lateinit var adapter: MessagesAdapter
    private var bottomSheetDialog: BottomSheetDialog? = null

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

        binding.fabCreateMessage.setOnClickListener {
            viewModel.showDrawer()
        }
    }

    private fun observeViewModel() {
        viewModel.state.messages.observe(this) { messages ->
            adapter.submitList(messages)
        }

        viewModel.state.loading.observe(this) { loadingState ->
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
        }

        viewModel.state.isRefreshing.observe(this) { isRefreshing ->
            binding.swipeRefresh.isRefreshing = isRefreshing
        }

        viewModel.state.isDrawerVisible.observe(this) { isVisible ->
            if (isVisible) {
                showCreateMessageBottomSheet()
            } else {
                hideCreateMessageBottomSheet()
            }
        }
    }

    private fun showCreateMessageBottomSheet() {
        if (bottomSheetDialog?.isShowing == true) return

        val bottomSheetBinding = BottomSheetCreateMessageBinding.inflate(layoutInflater)
        bottomSheetDialog = BottomSheetDialog(this)
        bottomSheetDialog?.setContentView(bottomSheetBinding.root)

        // Setup text input
        bottomSheetBinding.etMessage.doAfterTextChanged { text ->
            viewModel.onTextChanged(text?.toString() ?: "")
        }

        // Setup buttons
        bottomSheetBinding.btnCancel.setOnClickListener {
            bottomSheetDialog?.dismiss()
        }

        bottomSheetBinding.btnSubmit.setOnClickListener {
            viewModel.submitMessage()
        }

        // Observe submission state
        viewModel.state.isSubmitting.observe(this) { isSubmitting ->
            bottomSheetBinding.btnSubmit.isEnabled = !isSubmitting
            bottomSheetBinding.btnCancel.isEnabled = !isSubmitting
            bottomSheetBinding.etMessage.isEnabled = !isSubmitting
            bottomSheetBinding.progressBar.visibility = if (isSubmitting) View.VISIBLE else View.GONE
        }

        // Observe input text
        viewModel.state.inputText.observe(this) { text ->
            if (bottomSheetBinding.etMessage.text?.toString() != text) {
                bottomSheetBinding.etMessage.setText(text)
            }
            bottomSheetBinding.btnSubmit.isEnabled = text.isNotBlank() && viewModel.state.isSubmitting.value != true
        }

        bottomSheetDialog?.setOnDismissListener {
            viewModel.hideDrawer()
        }

        bottomSheetDialog?.show()
    }

    private fun hideCreateMessageBottomSheet() {
        bottomSheetDialog?.dismiss()
        bottomSheetDialog = null
    }
}
