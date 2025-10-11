package com.yornest.logger

/**
 * Simple logger interface
 * Matches the pattern used in the main YorNest app
 */
interface Logger {
    fun d(tag: String, message: String)
    fun e(tag: String, message: String, throwable: Throwable? = null)
}

class DefaultLogger : Logger {
    override fun d(tag: String, message: String) {
        println("DEBUG [$tag]: $message")
    }

    override fun e(tag: String, message: String, throwable: Throwable?) {
        println("ERROR [$tag]: $message")
        throwable?.printStackTrace()
    }
}
