//
//  RawTransaction.swift
//  EVMKit
//
//  Created by Sun on 2018/10/9.
//

import Foundation

import BigInt

// MARK: - RawTransaction

public class RawTransaction {
    // MARK: Properties

    let gasPrice: GasPrice
    let gasLimit: Int
    let to: Address
    let value: BigUInt
    let data: Data
    let nonce: Int

    // MARK: Lifecycle

    init(gasPrice: GasPrice, gasLimit: Int, to: Address, value: BigUInt, data: Data, nonce: Int) {
        self.gasPrice = gasPrice
        self.gasLimit = gasLimit
        self.to = to
        self.value = value
        self.data = data
        self.nonce = nonce
    }
}

// MARK: CustomStringConvertible

extension RawTransaction: CustomStringConvertible {
    public var description: String {
        "RAW TRANSACTION [gasPrice: \(gasPrice); gasLimit: \(gasLimit); to: \(to); value: \(value); data: \(data.sw.hexString)]"
    }
}
