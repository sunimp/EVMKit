//
//  GasPriceJsonRpc.swift
//  EvmKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import BigInt

class GasPriceJsonRpc: IntJsonRpc {
    init() {
        super.init(
            method: "eth_gasPrice",
            params: []
        )
    }
}
