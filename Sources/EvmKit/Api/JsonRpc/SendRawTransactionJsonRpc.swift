//
//  SendRawTransactionJsonRpc.swift
//  EvmKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import WWExtensions

class SendRawTransactionJsonRpc: DataJsonRpc {
    init(signedTransaction: Data) {
        super.init(
            method: "eth_sendRawTransaction",
            params: [signedTransaction.ww.hexString]
        )
    }
}
