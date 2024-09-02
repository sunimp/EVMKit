//
//  ContractEventInstance.swift
//
//  Created by Sun on 2021/6/3.
//

import Foundation

open class ContractEventInstance {
    // MARK: Properties

    public let contractAddress: Address

    // MARK: Lifecycle

    public init(contractAddress: Address) {
        self.contractAddress = contractAddress
    }

    // MARK: Functions

    open func tags(userAddress _: Address) -> [TransactionTag] {
        []
    }
}
