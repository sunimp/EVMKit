//
//  TransactionDecoration.swift
//  EVMKit
//
//  Created by Sun on 2022/4/7.
//

import Foundation

open class TransactionDecoration {
    // MARK: Lifecycle

    public init() { }

    // MARK: Functions

    open func tags() -> [TransactionTag] {
        []
    }
}
