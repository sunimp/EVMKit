//
//  SubscribeJsonRpc.swift
//
//  Created by Sun on 2020/8/28.
//

import Foundation

class SubscribeJsonRpc: StringJsonRpc {
    init(params: [Any]) {
        super.init(
            method: "eth_subscribe",
            params: params
        )
    }
}
