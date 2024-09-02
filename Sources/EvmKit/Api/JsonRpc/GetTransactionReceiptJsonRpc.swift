//
//  GetTransactionReceiptJsonRpc.swift
//
//  Created by Sun on 2020/8/28.
//

import Foundation

import WWExtensions

class GetTransactionReceiptJsonRpc: JsonRpc<RpcTransactionReceipt> {
    // MARK: Lifecycle

    init(transactionHash: Data) {
        super.init(
            method: "eth_getTransactionReceipt",
            params: [transactionHash.ww.hexString]
        )
    }

    // MARK: Overridden Functions

    override func parse(result: Any) throws -> RpcTransactionReceipt {
        try RpcTransactionReceipt(JSONObject: result)
    }
}
