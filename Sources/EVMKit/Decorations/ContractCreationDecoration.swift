//
//  ContractCreationDecoration.swift
//  EVMKit
//
//  Created by Sun on 2022/4/7.
//

import Foundation

public class ContractCreationDecoration: TransactionDecoration {
    override public func tags() -> [TransactionTag] {
        [
            TransactionTag(type: .contractCreation),
        ]
    }
}
