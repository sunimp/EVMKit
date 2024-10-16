//
//  TransactionSyncerStateStorage.swift
//  EVMKit
//
//  Created by Sun on 2022/6/1.
//

import Foundation

import GRDB

// MARK: - TransactionSyncerStateStorage

class TransactionSyncerStateStorage {
    // MARK: Properties

    private let dbPool: DatabasePool

    // MARK: Computed Properties

    var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()

        migrator.registerMigration("recreate TransactionSyncerState") { db in
            var oldStates = [TransactionSyncerState]()

            if try db.tableExists(TransactionSyncerState.databaseTableName) {
                oldStates = try TransactionSyncerState.fetchAll(db)

                try db.drop(table: TransactionSyncerState.databaseTableName)
            }

            try db.create(table: TransactionSyncerState.databaseTableName) { t in
                t.column(TransactionSyncerState.Columns.syncerID.name, .text).primaryKey(onConflict: .replace)
                t.column(TransactionSyncerState.Columns.lastBlockNumber.name, .integer).notNull()
            }

            for oldState in oldStates {
                try oldState.insert(db)
            }
        }

        migrator.registerMigration("truncate TransactionSyncerState") { db in
            try TransactionSyncerState.deleteAll(db)
        }

        migrator.registerMigration("remove all states after update transaction's tags") { db in
            try TransactionSyncerState.deleteAll(db)
        }

        return migrator
    }

    // MARK: Lifecycle

    init(databaseDirectoryURL: URL, databaseFileName: String) {
        let databaseURL = databaseDirectoryURL.appendingPathComponent("\(databaseFileName).sqlite")

        dbPool = try! DatabasePool(path: databaseURL.path)

        try! migrator.migrate(dbPool)
    }
}

extension TransactionSyncerStateStorage {
    func syncerState(syncerID: String) throws -> TransactionSyncerState? {
        try dbPool.read { db in
            try TransactionSyncerState.filter(TransactionSyncerState.Columns.syncerID == syncerID).fetchOne(db)
        }
    }

    func save(syncerState: TransactionSyncerState) throws {
        try dbPool.write { db in
            try syncerState.save(db)
        }
    }
}
