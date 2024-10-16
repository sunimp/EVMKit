//
//  OutgoingDecoration.swift
//  EVMKit
//
//  Created by Sun on 2022/4/7.
//

import Foundation

import BigInt

public class OutgoingDecoration: TransactionDecoration {
    // MARK: Properties

    public let to: Address
    public let value: BigUInt
    public let sentToSelf: Bool

    // MARK: Lifecycle

    init(to: Address, value: BigUInt, sentToSelf: Bool) {
        self.to = to
        self.value = value
        self.sentToSelf = sentToSelf
    }

    // MARK: Overridden Functions

    override public func tags() -> [TransactionTag] {
        var tags = [
            TransactionTag(type: .outgoing, protocol: .native, addresses: [to.hex]),
        ]

        if sentToSelf {
            tags.append(TransactionTag(type: .incoming, protocol: .native))
        }

        return tags
    }
}
