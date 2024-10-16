//
//  EstimateGasJsonRpc.swift
//  EVMKit
//
//  Created by Sun on 2020/8/28.
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
            params["value"] = "0x" + (amount == 0 ? "0" : amount.serialize().sw.hex.sw.removeLeadingZeros())
        }
        if let gasLimit {
            params["gas"] = "0x" + String(gasLimit, radix: 16).sw.removeLeadingZeros()
        }
        switch gasPrice {
        case let .legacy(gasPrice):
            params["gasPrice"] = "0x" + String(gasPrice, radix: 16).sw.removeLeadingZeros()
        case let .eip1559(maxFeePerGas, maxPriorityFeePerGas):
            params["maxFeePerGas"] = "0x" + String(maxFeePerGas, radix: 16).sw.removeLeadingZeros()
            params["maxPriorityFeePerGas"] = "0x" + String(maxPriorityFeePerGas, radix: 16).sw.removeLeadingZeros()
        }
        if let data {
            params["data"] = data.sw.hexString
        }

        super.init(
            method: "eth_estimateGas",
            params: [params]
        )
    }
}
