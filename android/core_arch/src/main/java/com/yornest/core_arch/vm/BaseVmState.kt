package com.yornest.core_arch.vm

import androidx.lifecycle.MutableLiveData

/**
 * Base state for ViewModels with loading state management
 * Matches the pattern used in the main YorNest app
 */
abstract class BaseVmState {
    val loading = MutableLiveData<LoadingState>(LoadingState.None)
}

/**
 * Loading states for UI
 */
sealed class LoadingState {
    object None : LoadingState()
    object Loading : LoadingState()
    data class Error(val message: String) : LoadingState()
}
