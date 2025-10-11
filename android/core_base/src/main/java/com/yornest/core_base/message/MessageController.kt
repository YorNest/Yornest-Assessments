package com.yornest.core_base.message

/**
 * Interface for showing messages to the user
 * Matches the pattern used in the main YorNest app
 */
interface MessageController {
    fun showMessage(message: String)
    fun showError(error: String)
    fun showError(error: Throwable)
}

class DefaultMessageController : MessageController {
    override fun showMessage(message: String) {
        // In a real app, this would show a Toast or Snackbar
        println("MESSAGE: $message")
    }

    override fun showError(error: String) {
        // In a real app, this would show a Toast or Snackbar
        println("ERROR: $error")
    }

    override fun showError(error: Throwable) {
        // In a real app, this would show a Toast or Snackbar
        println("ERROR: ${error.message}")
        error.printStackTrace()
    }
}


