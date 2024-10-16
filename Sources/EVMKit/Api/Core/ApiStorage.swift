//
//  ApiStorage.swift
//  EVMKit
//
//  Created by Sun on 2019/2/18.
//

import Foundation

import BigInt
import GRDB

// MARK: - ApiStorage

class ApiStorage {
    // MARK: Properties

    private let dbPool: DatabasePool

    // MARK: Computed Properties

    var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()

        migrator.registerMigration("createBlockchainStates") { db in
            try db.create(table: BlockchainState.databaseTableName) { t in
                t.column(BlockchainState.Columns.primaryKey.name, .text).notNull()
                t.column(BlockchainState.Columns.lastBlockHeight.name, .integer)

                t.primaryKey([BlockchainState.Columns.primaryKey.name], onConflict: .replace)
            }
        }

        migrator.registerMigration("createAccountStates") { db in
            if try db.tableExists("ethereumBalance") {
                try db.drop(table: "ethereumBalance")
            }

            try db.create(table: AccountState.databaseTableName) { t in
                t.column(AccountState.Columns.primaryKey.name, .text).notNull()
                t.column(AccountState.Columns.balance.name, .text).notNull()
                t.column(AccountState.Columns.nonce.name, .integer).notNull()

                t.primaryKey([AccountState.Columns.primaryKey.name], onConflict: .replace)
            }
        }

        return migrator
    }

    // MARK: Lifecycle

    init(databaseDirectoryURL: URL, databaseFileName: String) {
        let databaseURL = databaseDirectoryURL.appendingPathComponent("\(databaseFileName).sqlite")

        dbPool = try! DatabasePool(path: databaseURL.path)

        try? migrator.migrate(dbPool)
    }
}

// MARK: IApiStorage

extension ApiStorage: IApiStorage {
    var lastBlockHeight: Int? {
        try! dbPool.read { db in
            try BlockchainState.fetchOne(db)?.lastBlockHeight
        }
    }

    func save(lastBlockHeight: Int) {
        _ = try? dbPool.write { db in
            let state = try BlockchainState.fetchOne(db) ?? BlockchainState()
            state.lastBlockHeight = lastBlockHeight
            try state.insert(db)
        }
    }

    var accountState: AccountState? {
        try! dbPool.read { db in
            try AccountState.fetchOne(db)
        }
    }

    func save(accountState: AccountState) {
        _ = try? dbPool.write { db in
            try accountState.save(db)
        }
    }
}
