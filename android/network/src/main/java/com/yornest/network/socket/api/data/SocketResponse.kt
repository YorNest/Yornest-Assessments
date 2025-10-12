package com.yornest.network.socket.api.data

import com.yornest.network.ChangesType

class SocketResponse<Response : Any?>(
    val data: Response?,
    val changesType: ChangesType
) {

    val dataNotNull: Response
        get() = data!!
}
