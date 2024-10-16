//
//  GetTransactionByHashJsonRpc.swift
//  EVMKit
//
//  Created by Sun on 2020/8/28.
//

import Foundation

import SWExtensions

class GetTransactionByHashJsonRpc: JsonRpc<RpcTransaction> {
    // MARK: Lifecycle

    init(transactionHash: Data) {
        super.init(
            method: "eth_getTransactionByHash",
            params: [transactionHash.sw.hexString]
        )
    }

    // MARK: Overridden Functions

    override func parse(result: Any) throws -> RpcTransaction {
        try RpcTransaction(JSONObject: result)
    }
}
