//
//  GasPriceRpc.swift
//
//  Created by Sun on 2022/2/9.
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
