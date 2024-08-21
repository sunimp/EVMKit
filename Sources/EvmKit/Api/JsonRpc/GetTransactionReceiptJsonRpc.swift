//
//  GetTransactionReceiptJsonRpc.swift
//  EvmKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import WWExtensions

class GetTransactionReceiptJsonRpc: JsonRpc<RpcTransactionReceipt> {
    init(transactionHash: Data) {
        super.init(
            method: "eth_getTransactionReceipt",
            params: [transactionHash.ww.hexString]
        )
    }

    override func parse(result: Any) throws -> RpcTransactionReceipt {
        try RpcTransactionReceipt(JSONObject: result)
    }
}
