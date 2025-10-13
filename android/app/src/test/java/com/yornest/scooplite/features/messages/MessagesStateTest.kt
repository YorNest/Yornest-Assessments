package com.yornest.scooplite.features.messages

import androidx.arch.core.executor.testing.InstantTaskExecutorRule
import androidx.lifecycle.LiveData
import androidx.lifecycle.Observer
import com.yornest.scooplite.TestUtils
import org.junit.Assert.*
import org.junit.Before
import org.junit.Rule
import org.junit.Test

/**
 * Extension function to get the value of LiveData for testing
 */
fun <T> LiveData<T>.getTestValue(): T? {
    var value: T? = null
    val observer = Observer<T> { value = it }

    observeForever(observer)
    removeObserver(observer)

    return value
}

/**
 * Unit tests for MessagesState
 * 
 * This test has an intentional issue that candidates need to identify and fix
 * It demonstrates testing state management in the MVVM pattern
 */
class MessagesStateTest {

    @get:Rule
    val instantTaskExecutorRule = InstantTaskExecutorRule()

    private lateinit var messagesState: MessagesState

    @Before
    fun setup() {
        messagesState = MessagesState()
    }

    @Test
    fun `initial state should do something`() {
        // Write a test
    }
}
