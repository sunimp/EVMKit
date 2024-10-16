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
//    let chain: Chain = .ethereum
//    let rpcSource: RpcSource = .ethereumInfuraWebsocket(
//        projectID: "2a1306f1d12f4c109a4d4fb9be46b02e",
//        projectSecret: "fc479a9290b64a84a15fa6544a130218"
//    )
//    let transactionSource: TransactionSource = .ethereumEtherscan(apiKey: "GKNHXT22ED7PRVCKZATFZQD1YI7FK9AAYE")
//    let defaultsWords = "apart approve black  comfort steel spin real renew tone primary key cherry"
//    let defaultsWatchAddress = "0xDc3EAB13c26C0cA48843c16d1B27Ff8760515016"
    
    // Sepolia
    let chain: Chain = .ethereumSepolia
    let rpcSource: RpcSource = .ethereumSepoliaHttp(
        projectID: "b369a5cf61c649d4946de59ae753c844",
        projectSecret: "1bccb91aa7794661a1e2c936306eec8e"
    )
    
    let transactionSource: TransactionSource = .sepoliaEtherscan(apiKey: "FHMKY85P9N5U1GXIC7H9PTKBECZW2Z8FA5")

    let defaultsWords = "vivid episode rabbit vapor they expose excess ten fog old ridge abandon"
    let defaultsWatchAddress = "0xBBDb57ece6E9901D210Ad34FDc594f06b7a82A46"
}
