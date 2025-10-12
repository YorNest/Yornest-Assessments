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
    fun `initial state should have empty messages list`() {
        // Test the initial state
        val initialMessages = messagesState.messages.getTestValue()
        assertNotNull("Messages should not be null", initialMessages)
        assertTrue("Messages should be empty initially", initialMessages!!.isEmpty())
    }

    @Test
    fun `initial state should have refreshing set to false`() {
        // Test the initial refreshing state
        val initialRefreshing = messagesState.isRefreshing.getTestValue()
        assertNotNull("Refreshing state should not be null", initialRefreshing)
        assertFalse("Refreshing should be false initially", initialRefreshing!!)
    }

    @Test
    fun `setting messages should update the state`() {
        // Given
        val testMessages = TestUtils.createSampleMessages(2)
        
        // When
        messagesState.messages.postValue(testMessages)
        
        // Then
        val updatedMessages = messagesState.messages.getTestValue()
        assertNotNull("Messages should not be null after update", updatedMessages)
        assertEquals("Messages count should match", 2, updatedMessages!!.size)
        assertEquals("First message should match", testMessages[0], updatedMessages[0])
    }

    @Test
    fun `setting refreshing state should update correctly`() {
        // When
        messagesState.isRefreshing.postValue(true)
        
        // Then
        val refreshingState = messagesState.isRefreshing.getTestValue()
        assertNotNull("Refreshing state should not be null", refreshingState)
        assertTrue("Refreshing should be true after setting", refreshingState!!)
    }

    @Test
    fun `INTENTIONAL_BUG_messages_state_should_handle_null_values`() {
        // This test has an intentional bug - it tries to set null values
        // Candidates should identify that this violates the state contract
        // and either fix the test or improve the state class to handle this case
        
        // FIXME: This test will fail - candidates need to fix it
        messagesState.messages.postValue(null)
        
        val messages = messagesState.messages.getTestValue()
        // This assertion will fail because we're setting null but expecting empty list
        assertTrue("Messages should default to empty list when null is set", 
                  messages?.isEmpty() == true)
    }
}
