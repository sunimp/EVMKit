//
//  GetStorageAtJsonRpc.swift
//  EvmKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import WWExtensions

class GetStorageAtJsonRpc: DataJsonRpc {
    init(contractAddress: Address, positionData: Data, defaultBlockParameter: DefaultBlockParameter) {
        super.init(
            method: "eth_getStorageAt",
            params: [contractAddress.hex, positionData.ww.hexString, defaultBlockParameter.raw]
        )
    }
}
