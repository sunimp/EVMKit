//
//  TransactionSyncerState.swift
//  EvmKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import GRDB

class TransactionSyncerState: Record {
    let syncerID: String
    let lastBlockNumber: Int

    init(syncerID: String, lastBlockNumber: Int) {
        self.syncerID = syncerID
        self.lastBlockNumber = lastBlockNumber

        super.init()
    }

    override public class var databaseTableName: String {
        "transactionSyncerStates"
    }

    enum Columns: String, ColumnExpression, CaseIterable {
        case syncerID
        case lastBlockNumber
    }

    required init(row: Row) throws {
        syncerID = row[Columns.syncerID]
        lastBlockNumber = row[Columns.lastBlockNumber]

        try super.init(row: row)
    }

    override public func encode(to container: inout PersistenceContainer) throws {
        container[Columns.syncerID] = syncerID
        container[Columns.lastBlockNumber] = lastBlockNumber
    }
}
