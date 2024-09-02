//
//  SendRawTransactionJsonRpc.swift
//
//  Created by Sun on 2020/8/28.
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
