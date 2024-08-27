//
//  Configuration.swift
//  EvmKit-Example
//
//  Created by Sun on 2024/8/21.
//

import UIKit

import EvmKit
import WWToolKit

class Configuration {
    static let shared = Configuration()

    let minLogLevel: Logger.Level = .error

    let chain = Chain(
        id: 15,
        coinType: 1,
        syncInterval: 15,
        isEIP1559Supported: false
    )
    let rpcSource: RpcSource = .webSocket(url: URL(string: "ws://10.0.188.216:8546")!, auth: nil)
    
    let transactionSource: TransactionSource = .custom(name: "Private", apiURL: "http://10.0.188.216:8088", txURL: "http://10.0.188.216:8088/getTransactionDetail")

    let defaultsWords = "vivid episode rabbit vapor they expose excess ten fog old ridge abandon"
    let defaultsWatchAddress = "0x1243724dB8815f81AD9956761ff0099cd2b865CC"
}
