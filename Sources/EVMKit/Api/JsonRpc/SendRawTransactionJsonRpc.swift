//
//  SendRawTransactionJsonRpc.swift
//  EVMKit
//
//  Created by Sun on 2020/8/28.
//

import Foundation

import SWExtensions

class SendRawTransactionJsonRpc: DataJsonRpc {
    init(signedTransaction: Data) {
        super.init(
            method: "eth_sendRawTransaction",
            params: [signedTransaction.sw.hexString]
        )
    }
}
