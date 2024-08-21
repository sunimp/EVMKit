//
//  ContractCreationDecoration.swift
//  EvmKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

public class ContractCreationDecoration: TransactionDecoration {
    override public func tags() -> [TransactionTag] {
        [
            TransactionTag(type: .contractCreation),
        ]
    }
}
