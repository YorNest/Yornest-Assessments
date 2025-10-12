package com.yornest.core_base.lifecycle.process

import androidx.lifecycle.LifecycleOwner

@RequiresOptIn(message = "Doesn't guarantee to be called for Application")
@Retention(AnnotationRetention.BINARY)
@Target(AnnotationTarget.FUNCTION)
annotation class ProcessLifecycleDestroy

interface ProcessLifecycleListenerDelegate {

    fun onCreate(owner: LifecycleOwner) {}

    fun onResume(owner: LifecycleOwner) {}

    fun onStart(owner: LifecycleOwner) {}

    fun onStop(owner: LifecycleOwner) {}

    fun onPause(owner: LifecycleOwner) {}

    @ProcessLifecycleDestroy
    fun onDestroy(owner: LifecycleOwner) {
    }
}
