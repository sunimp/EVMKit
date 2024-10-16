//
//  TransactionSyncerState.swift
//  EVMKit
//
//  Created by Sun on 2022/6/1.
//

import Foundation

import GRDB

class TransactionSyncerState: Record {
    // MARK: Nested Types

    enum Columns: String, ColumnExpression, CaseIterable {
        case syncerID
        case lastBlockNumber
    }

    // MARK: Overridden Properties

    override public class var databaseTableName: String {
        "transactionSyncerStates"
    }

    // MARK: Properties

    let syncerID: String
    let lastBlockNumber: Int

    // MARK: Lifecycle

    init(syncerID: String, lastBlockNumber: Int) {
        self.syncerID = syncerID
        self.lastBlockNumber = lastBlockNumber

        super.init()
    }

    required init(row: Row) throws {
        syncerID = row[Columns.syncerID]
        lastBlockNumber = row[Columns.lastBlockNumber]

        try super.init(row: row)
    }

    // MARK: Overridden Functions

    override public func encode(to container: inout PersistenceContainer) throws {
        container[Columns.syncerID] = syncerID
        container[Columns.lastBlockNumber] = lastBlockNumber
    }
}
