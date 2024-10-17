//
//  Configuration.swift
//  EVMKit-Example
//
//  Created by Sun on 2024/8/21.
//

import UIKit

import EVMKit
import SWToolKit

final class Configuration {
    
    static let shared = Configuration()

    let minLogLevel: Logger.Level = .error

    // Ethereum
    let chain: Chain = .ethereum
    let rpcSource: RpcSource = .ethereumInfuraWebsocket(
        projectID: "2a1306f1d12f4c109a4d4fb9be46b02e",
        projectSecret: "fc479a9290b64a84a15fa6544a130218"
    )
    let transactionSource: TransactionSource = .ethereumEtherscan(apiKey: "GKNHXT22ED7PRVCKZATFZQD1YI7FK9AAYE")
    let defaultsWords = "apart approve black  comfort steel spin real renew tone primary key cherry"
    let defaultsWatchAddress = "0xDc3EAB13c26C0cA48843c16d1B27Ff8760515016"
    
    // Sepolia
//    let chain: Chain = .ethereumSepolia
//    let rpcSource: RpcSource = .ethereumSepoliaHttp(
//        projectID: "",
//        projectSecret: ""
//    )
//    
//    let transactionSource: TransactionSource = .sepoliaEtherscan(apiKey: "")
//
//    let defaultsWords = ""
//    let defaultsWatchAddress = "0xBBDb57ece6E9901D210Ad34FDc594f06b7a82A46"
    
    // Private
//    let chain = Chain(
//        id: 12345,
//        coinType: 1,
//        syncInterval: 15,
//        isEIP1559Supported: false
//    )
//    let rpcSource: RpcSource = .webSocket(url: URL(string: "")!, auth: nil)
//    
//    let transactionSource: TransactionSource = .custom(name: "Private", apiURL: "", txURL: "")
//    
//    let defaultsWords = ""
//    let defaultsWatchAddress = "0x1243724dB8815f81AD9956761ff0099cd2b865CC"
}
