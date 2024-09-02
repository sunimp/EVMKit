//
//  GetStorageAtJsonRpc.swift
//
//  Created by Sun on 2020/8/28.
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
