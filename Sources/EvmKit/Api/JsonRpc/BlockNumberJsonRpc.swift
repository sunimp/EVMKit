//
//  BlockNumberJsonRpc.swift
//
//  Created by Sun on 2020/8/28.
//

import Foundation

class BlockNumberJsonRpc: IntJsonRpc {
    init() {
        super.init(method: "eth_blockNumber")
    }
}
