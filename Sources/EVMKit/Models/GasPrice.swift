//
//  GasPrice.swift
//  EVMKit
//
//  Created by Sun on 2022/2/9.
//

import Foundation

// MARK: - GasPrice

public enum GasPrice {
    case legacy(gasPrice: Int)
    case eip1559(maxFeePerGas: Int, maxPriorityFeePerGas: Int)

    // MARK: Computed Properties

    public var max: Int {
        switch self {
        case let .legacy(gasPrice): gasPrice
        case let .eip1559(maxFeePerGas, _): maxFeePerGas
        }
    }
}

// MARK: CustomStringConvertible

extension GasPrice: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .legacy(gasPrice): "Legacy(\(gasPrice))"
        case let .eip1559(maxFeePerGas, maxPriorityFeePerGas): "EIP1559(\(maxFeePerGas),\(maxPriorityFeePerGas))"
        }
    }
}
