package com.yornest.network

enum class ChangesType {
    ADDED,
    MODIFIED,
    REMOVED;

    companion object {

        fun fromName(name: String): ChangesType =
            when (name) {
                "update" -> MODIFIED
                "create" -> ADDED
                "delete" -> REMOVED
                else -> MODIFIED
            }
    }
}
