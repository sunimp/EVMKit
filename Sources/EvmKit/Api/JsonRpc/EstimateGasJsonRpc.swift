//
//  EstimateGasJsonRpc.swift
//  EvmKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import BigInt

class EstimateGasJsonRpc: IntJsonRpc {
    init(from: Address, to: Address?, amount: BigUInt?, gasLimit: Int?, gasPrice: GasPrice, data: Data?) {
        var params: [String: Any] = [
            "from": from.hex,
        ]

        if let to {
            params["to"] = to.hex
        }
        if let amount {
            params["value"] = "0x" + (amount == 0 ? "0" : amount.serialize().ww.hex.ww.removeLeadingZeros())
        }
        if let gasLimit {
            params["gas"] = "0x" + String(gasLimit, radix: 16).ww.removeLeadingZeros()
        }
        switch gasPrice {
        case let .legacy(gasPrice):
            params["gasPrice"] = "0x" + String(gasPrice, radix: 16).ww.removeLeadingZeros()
        case let .eip1559(maxFeePerGas, maxPriorityFeePerGas):
            params["maxFeePerGas"] = "0x" + String(maxFeePerGas, radix: 16).ww.removeLeadingZeros()
            params["maxPriorityFeePerGas"] = "0x" + String(maxPriorityFeePerGas, radix: 16).ww.removeLeadingZeros()
        }
        if let data {
            params["data"] = data.ww.hexString
        }

        super.init(
            method: "eth_estimateGas",
            params: [params]
        )
    }
}
