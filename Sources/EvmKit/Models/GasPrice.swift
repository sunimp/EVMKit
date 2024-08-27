//
//  GasPrice.swift
//  EvmKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

// MARK: - GasPrice

public enum GasPrice {
    case legacy(gasPrice: Int)
    case eip1559(maxFeePerGas: Int, maxPriorityFeePerGas: Int)

    public var max: Int {
        switch self {
        case .legacy(let gasPrice): gasPrice
        case .eip1559(let maxFeePerGas, _): maxFeePerGas
        }
    }
}

// MARK: CustomStringConvertible

extension GasPrice: CustomStringConvertible {
    public var description: String {
        switch self {
        case .legacy(let gasPrice): "Legacy(\(gasPrice))"
        case .eip1559(let maxFeePerGas, let maxPriorityFeePerGas): "EIP1559(\(maxFeePerGas),\(maxPriorityFeePerGas))"
        }
    }
}
