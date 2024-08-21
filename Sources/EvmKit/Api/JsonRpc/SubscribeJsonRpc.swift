//
//  SubscribeJsonRpc.swift
//  EvmKit
//
//  Created by Sun on 2024/8/21.
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
