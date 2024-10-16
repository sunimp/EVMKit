//
//  GetStorageAtJsonRpc.swift
//  EVMKit
//
//  Created by Sun on 2020/8/28.
//

import Foundation

import SWExtensions

class GetStorageAtJsonRpc: DataJsonRpc {
    init(contractAddress: Address, positionData: Data, defaultBlockParameter: DefaultBlockParameter) {
        super.init(
            method: "eth_getStorageAt",
            params: [contractAddress.hex, positionData.sw.hexString, defaultBlockParameter.raw]
        )
    }
}
