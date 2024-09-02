//
//  EIP20Balance.swift
//
//  Created by Sun on 2019/4/18.
//

import Foundation

import BigInt
import GRDB

class EIP20Balance: Record {
    // MARK: Nested Types

    enum Columns: String, ColumnExpression {
        case contractAddress
        case value
    }

    // MARK: Overridden Properties

    override class var databaseTableName: String {
        "eip20_balances"
    }

    // MARK: Properties

    let contractAddress: String
    let value: BigUInt?

    // MARK: Lifecycle

    init(contractAddress: String, value: BigUInt?) {
        self.contractAddress = contractAddress
        self.value = value

        super.init()
    }

    required init(row: Row) throws {
        contractAddress = row[Columns.contractAddress]
        value = row[Columns.value]

        try super.init(row: row)
    }

    // MARK: Overridden Functions

    override func encode(to container: inout PersistenceContainer) throws {
        container[Columns.contractAddress] = contractAddress
        container[Columns.value] = value
    }
}
