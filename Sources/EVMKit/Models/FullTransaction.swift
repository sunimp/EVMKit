//
//  FullTransaction.swift
//  EVMKit
//
//  Created by Sun on 2020/12/16.
//

import Foundation

public class FullTransaction {
    // MARK: Properties

    public let transaction: Transaction
    public let decoration: TransactionDecoration

    // MARK: Lifecycle

    init(transaction: Transaction, decoration: TransactionDecoration) {
        self.transaction = transaction
        self.decoration = decoration
    }
}
