//
//  TransactionData.swift
//
//  Created by Sun on 2020/11/3.
//

import Foundation

import BigInt

// MARK: - TransactionData

public struct TransactionData {
    // MARK: Properties

    public var to: Address
    public var value: BigUInt
    public var input: Data

    // MARK: Lifecycle

    public init(to: Address, value: BigUInt, input: Data) {
        self.to = to
        self.value = value
        self.input = input
    }
}

// MARK: Equatable

extension TransactionData: Equatable {
    public static func == (lhs: TransactionData, rhs: TransactionData) -> Bool {
        lhs.to == rhs.to && lhs.value == rhs.value && lhs.input == rhs.input
    }
}
