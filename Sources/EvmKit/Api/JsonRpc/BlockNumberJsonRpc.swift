//
//  BlockNumberJsonRpc.swift
//  EvmKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

class BlockNumberJsonRpc: IntJsonRpc {
    init() {
        super.init(method: "eth_blockNumber")
    }
}
