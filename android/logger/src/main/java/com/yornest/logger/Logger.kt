package com.yornest.logger

import android.util.Log

/**
 * AppLogger object that matches the pattern used in the main YorNest app
 */
object AppLogger {

    private const val DEFAULT_TAG = "SCOOPLITE"

    fun logD(message: String, tag: String = DEFAULT_TAG) {
        Log.d(tag, message)
    }

    fun logE(message: String, tag: String = DEFAULT_TAG) {
        Log.e(tag, message)
    }

    fun logE(message: String, throwable: Throwable, tag: String = DEFAULT_TAG) {
        Log.e(tag, message, throwable)
    }
}

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
