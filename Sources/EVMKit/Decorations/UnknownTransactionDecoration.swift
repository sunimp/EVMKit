//
//  UnknownTransactionDecoration.swift
//  EVMKit
//
//  Created by Sun on 2022/4/7.
//

import Foundation

import BigInt

open class UnknownTransactionDecoration: TransactionDecoration {
    // MARK: Properties

    public let fromAddress: Address?
    public let internalTransactions: [InternalTransaction]
    public let eventInstances: [ContractEventInstance]

    private let userAddress: Address
    private let toAddress: Address?
    private let value: BigUInt?

    // MARK: Computed Properties

    private var tagsFromInternalTransactions: [TransactionTag] {
        let value = value ?? 0
        let incomingInternalTransactions = internalTransactions.filter { $0.to == userAddress }

        var outgoingValue: BigUInt = 0
        if fromAddress == userAddress {
            outgoingValue = value
        }
        var incomingValue: BigUInt = 0
        if toAddress == userAddress {
            incomingValue = value
        }
        for incomingInternalTransaction in incomingInternalTransactions {
            incomingValue += incomingInternalTransaction.value
        }

        // if has value or has internalTxs must add EVM tag
        if outgoingValue == 0, incomingValue == 0 {
            return []
        }

        var tags = [TransactionTag]()
        let addresses = [fromAddress, toAddress]
            .compactMap { $0 }
            .filter { $0 != userAddress }
            .map { $0.hex }

        if incomingValue > outgoingValue {
            tags.append(TransactionTag(type: .incoming, protocol: .native, addresses: addresses))
        } else if outgoingValue > incomingValue {
            tags.append(TransactionTag(type: .outgoing, protocol: .native, addresses: addresses))
        }

        return tags
    }

    private var tagsFromEventInstances: [TransactionTag] {
        var tags = [TransactionTag]()

        for eventInstance in eventInstances {
            tags.append(contentsOf: eventInstance.tags(userAddress: userAddress))
        }

        return tags
    }

    // MARK: Lifecycle

    public init(
        userAddress: Address,
        fromAddress: Address?,
        toAddress: Address?,
        value: BigUInt?,
        internalTransactions: [InternalTransaction],
        eventInstances: [ContractEventInstance]
    ) {
        self.userAddress = userAddress
        self.fromAddress = fromAddress
        self.toAddress = toAddress
        self.value = value
        self.internalTransactions = internalTransactions
        self.eventInstances = eventInstances
    }

    // MARK: Overridden Functions

    override public func tags() -> [TransactionTag] {
        Array(Set(tagsFromInternalTransactions + tagsFromEventInstances))
    }
}
