package com.yornest.core_base.lifecycle.process

import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleObserver
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.OnLifecycleEvent

class ProcessLifecycleListener(
    private val delegates: Set<ProcessLifecycleListenerDelegate>
) : LifecycleObserver {

    @OnLifecycleEvent(Lifecycle.Event.ON_CREATE)
    fun onCreate(owner: LifecycleOwner) {
        delegates.forEach {
            it.onCreate(owner)
        }
    }

    @OnLifecycleEvent(Lifecycle.Event.ON_START)
    fun onStart(owner: LifecycleOwner) {
        delegates.forEach {
            it.onStart(owner)
        }
    }

    @OnLifecycleEvent(Lifecycle.Event.ON_RESUME)
    fun onResume(owner: LifecycleOwner) {
        delegates.forEach {
            it.onResume(owner)
        }
    }

    @OnLifecycleEvent(Lifecycle.Event.ON_PAUSE)
    fun onPause(owner: LifecycleOwner) {
        delegates.forEach {
            it.onPause(owner)
        }
    }

    @OnLifecycleEvent(Lifecycle.Event.ON_STOP)
    fun onStop(owner: LifecycleOwner) {
        delegates.forEach {
            it.onStop(owner)
        }
    }

    @ProcessLifecycleDestroy
    @OnLifecycleEvent(Lifecycle.Event.ON_DESTROY)
    fun onDestroy(owner: LifecycleOwner) {
        delegates.forEach {
            it.onDestroy(owner)
        }
    }
}
