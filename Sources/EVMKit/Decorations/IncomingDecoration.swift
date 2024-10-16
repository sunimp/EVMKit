//
//  IncomingDecoration.swift
//  EVMKit
//
//  Created by Sun on 2022/4/7.
//

import Foundation

import BigInt

public class IncomingDecoration: TransactionDecoration {
    // MARK: Properties

    public let from: Address
    public let value: BigUInt

    // MARK: Lifecycle

    init(from: Address, value: BigUInt) {
        self.from = from
        self.value = value
    }

    // MARK: Overridden Functions

    override public func tags() -> [TransactionTag] {
        [
            TransactionTag(type: .incoming, protocol: .native, addresses: [from.hex]),
        ]
    }
}
