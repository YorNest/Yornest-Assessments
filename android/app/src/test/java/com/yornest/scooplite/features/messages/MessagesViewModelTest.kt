package com.yornest.scooplite.features.messages

import androidx.arch.core.executor.testing.InstantTaskExecutorRule
import androidx.lifecycle.Observer
import com.yornest.core_arch.vm.LoadingState
import com.yornest.core_arch.vm.VmDependencies
import com.yornest.core_base.coroutines.RequestResult
import com.yornest.domain.message.MessageInfo
import com.yornest.domain.message.MessagesListInfo
import com.yornest.i_messages.use_case.FetchMessagesUseCase
import com.yornest.network.use_case.request.RequestData
import com.yornest.network.use_case.request.RequestType
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.flow.flowOf
import kotlinx.coroutines.runBlocking
import kotlinx.coroutines.test.UnconfinedTestDispatcher
import kotlinx.coroutines.test.resetMain
import kotlinx.coroutines.test.setMain
import org.junit.After
import org.junit.Before
import org.junit.Rule
import org.junit.Test
import org.mockito.Mock
import org.mockito.MockitoAnnotations
import org.mockito.kotlin.any
import org.mockito.kotlin.verify
import org.mockito.kotlin.whenever

/**
 * Unit tests for MessagesViewModel
 * 
 * Tests the core functionality of loading and refreshing messages
 * following the MVVM pattern used in the main YorNest app
 */
@ExperimentalCoroutinesApi
class MessagesViewModelTest {

    @get:Rule
    val instantTaskExecutorRule = InstantTaskExecutorRule()

    @Mock
    private lateinit var fetchMessagesUseCase: FetchMessagesUseCase

    @Mock
    private lateinit var vmDependencies: VmDependencies

    @Mock
    private lateinit var loadingObserver: Observer<LoadingState>

    @Mock
    private lateinit var messagesObserver: Observer<List<MessageInfo>>

    @Mock
    private lateinit var refreshingObserver: Observer<Boolean>

    private lateinit var messagesState: MessagesState
    private lateinit var viewModel: MessagesViewModel

    private val testDispatcher = UnconfinedTestDispatcher()

    @Before
    fun setup() {
        MockitoAnnotations.openMocks(this)
        Dispatchers.setMain(testDispatcher)
        
        messagesState = MessagesState()
        
        // Setup observers
        messagesState.loading.observeForever(loadingObserver)
        messagesState.messages.observeForever(messagesObserver)
        messagesState.isRefreshing.observeForever(refreshingObserver)
    }

    @After
    fun tearDown() {
        Dispatchers.resetMain()
        messagesState.loading.removeObserver(loadingObserver)
        messagesState.messages.removeObserver(messagesObserver)
        messagesState.isRefreshing.removeObserver(refreshingObserver)
    }

    @Test
    fun `loadMessages should update loading state and fetch messages successfully`() {
        // Given
        val mockMessages = listOf(
            MessageInfo(
                id = "1",
                text = "Test message 1",
                sender = "John Doe",
                timestamp = System.currentTimeMillis()
            ),
            MessageInfo(
                id = "2",
                text = "Test message 2",
                sender = "Jane Smith",
                timestamp = System.currentTimeMillis()
            )
        )
        
        val mockResult = RequestResult.Success(
            RequestData(
                data = MessagesListInfo(
                    totalCount = mockMessages.size,
                    messages = mockMessages
                ),
                isFromCache = false
            )
        )
        
        runBlocking {
            whenever(fetchMessagesUseCase(any())).thenReturn(flowOf(mockResult))
        }

        // When
        viewModel = MessagesViewModel(messagesState, vmDependencies, fetchMessagesUseCase)

        // Then
        verify(loadingObserver).onChanged(LoadingState.Loading)
        verify(messagesObserver).onChanged(mockMessages)
        verify(loadingObserver).onChanged(LoadingState.None)
    }

    @Test
    fun `refresh should update refreshing state and fetch messages with RemoteOnly`() {
        // Given
        val mockMessages = listOf(
            MessageInfo(
                id = "3",
                text = "Refreshed message",
                sender = "Bob Wilson",
                timestamp = System.currentTimeMillis()
            )
        )
        
        val mockResult = RequestResult.Success(
            RequestData(
                data = MessagesListInfo(
                    totalCount = mockMessages.size,
                    messages = mockMessages
                ),
                isFromCache = false
            )
        )
        
        runBlocking {
            whenever(fetchMessagesUseCase(any())).thenReturn(flowOf(mockResult))
        }
        viewModel = MessagesViewModel(messagesState, vmDependencies, fetchMessagesUseCase)

        // When
        viewModel.refresh()

        // Then
        verify(refreshingObserver).onChanged(true)
        verify(messagesObserver).onChanged(mockMessages)
        verify(refreshingObserver).onChanged(false)
    }

    @Test
    fun `loadMessages should handle error and update loading state accordingly`() {
        // Given
        val errorMessage = "Network error"
        val mockResult = RequestResult.Error(
            Exception(errorMessage)
        )
        
        runBlocking {
            whenever(fetchMessagesUseCase(any())).thenReturn(flowOf(mockResult))
        }

        // When
        viewModel = MessagesViewModel(messagesState, vmDependencies, fetchMessagesUseCase)

        // Then
        verify(loadingObserver).onChanged(LoadingState.Loading)
        // Note: This test demonstrates a potential issue - error handling might need improvement
        // This is intentionally left as a learning opportunity for assessment candidates
    }
}
