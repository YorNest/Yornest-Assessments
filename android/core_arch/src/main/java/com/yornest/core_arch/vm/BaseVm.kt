package com.yornest.core_arch.vm

import androidx.annotation.MainThread
import androidx.lifecycle.ViewModel
import com.yornest.core_base.coroutines.RequestResult
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Job
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancelChildren
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import kotlin.coroutines.CoroutineContext

/**
 * Base ViewModel class that matches the pattern used in the main YorNest app
 */
abstract class BaseVm<S : BaseVmState>(
    val state: S,
    protected val dependencies: VmDependencies
) : ViewModel(),
    CoroutineScope {

    private val parentJob = SupervisorJob()

    override val coroutineContext: CoroutineContext = dependencies.dispatchers.default() + parentJob

    override fun onCleared() {
        parentJob.cancelChildren()
    }

    @MainThread
    protected open fun onError(error: Throwable) {
        state.loading.postValue(LoadingState.None)
        if (shouldIgnoreError(error)) {
            return
        }
        showErrorMessage(error)
    }

    protected open fun shouldIgnoreError(error: Throwable): Boolean = false

    protected suspend fun runOnUi(block: suspend () -> Unit) =
        withContext(dependencies.dispatchers.main()) {
            block()
        }

    protected fun launchOnUi(block: suspend () -> Unit): Job = launch(dependencies.dispatchers.main()) {
        block()
    }

    protected suspend fun <T> RequestResult<T>.handleResult(
        block: suspend (T) -> Unit
    ) = runOnUi {
        when (val result = this@handleResult) {
            is RequestResult.Success -> block(result.data)
            is RequestResult.Error -> onError(result.error)
        }
    }

    protected suspend fun <T> RequestResult<T>.handleResultWithError(
        resultBlock: suspend (T) -> Unit,
        errorBlock: suspend (Throwable) -> Unit
    ) = runOnUi {
        when (val result = this@handleResultWithError) {
            is RequestResult.Success -> resultBlock(result.data)
            is RequestResult.Error -> errorBlock(result.error)
        }
    }

    @MainThread
    protected open fun showErrorMessage(error: Throwable) {
        dependencies.messageController.showError(error)
    }

    open fun exit() {
        dependencies.router.exit()
    }
}
