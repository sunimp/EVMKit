//
//  GetBlockByNumberJsonRpc.swift
//
//  Created by Sun on 2020/8/28.
//

import Foundation

class GetBlockByNumberJsonRpc: JsonRpc<RpcBlock> {
    // MARK: Lifecycle

    init(number: Int) {
        super.init(
            method: "eth_getBlockByNumber",
            params: ["0x" + String(number, radix: 16), false]
        )
    }

    // MARK: Overridden Functions

    override func parse(result: Any) throws -> RpcBlock {
        try RpcBlock(JSONObject: result)
    }
}
