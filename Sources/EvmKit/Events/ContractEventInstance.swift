//
//  ContractEventInstance.swift
//  EvmKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

open class ContractEventInstance {
    public let contractAddress: Address

    public init(contractAddress: Address) {
        self.contractAddress = contractAddress
    }

    open func tags(userAddress _: Address) -> [TransactionTag] {
        []
    }
}
