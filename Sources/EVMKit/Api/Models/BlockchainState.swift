//
//  BlockchainState.swift
//  EVMKit
//
//  Created by Sun on 2019/2/18.
//

import Foundation

import GRDB

class BlockchainState: Record {
    // MARK: Nested Types

    enum Columns: String, ColumnExpression {
        case primaryKey
        case lastBlockHeight
    }

    // MARK: Static Properties

    private static let primaryKey = "primaryKey"

    // MARK: Overridden Properties

    override class var databaseTableName: String {
        "blockchainStates"
    }

    // MARK: Properties

    var lastBlockHeight: Int?

    private let primaryKey: String = BlockchainState.primaryKey

    // MARK: Lifecycle

    override init() {
        super.init()
    }

    required init(row: Row) throws {
        lastBlockHeight = row[Columns.lastBlockHeight]

        try super.init(row: row)
    }

    // MARK: Overridden Functions

    override func encode(to container: inout PersistenceContainer) throws {
        container[Columns.primaryKey] = primaryKey
        container[Columns.lastBlockHeight] = lastBlockHeight
    }
}
