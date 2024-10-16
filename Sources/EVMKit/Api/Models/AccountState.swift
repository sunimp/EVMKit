//
//  AccountState.swift
//  EVMKit
//
//  Created by Sun on 2021/1/8.
//

import Foundation

import BigInt
import GRDB

// MARK: - AccountState

public class AccountState: Record {
    // MARK: Nested Types

    enum Columns: String, ColumnExpression {
        case primaryKey
        case balance
        case nonce
    }

    // MARK: Static Properties

    private static let primaryKey = "primaryKey"

    // MARK: Overridden Properties

    override public class var databaseTableName: String {
        "account_states"
    }

    // MARK: Properties

    public let balance: BigUInt
    public let nonce: Int

    private let primaryKey: String = AccountState.primaryKey

    // MARK: Lifecycle

    init(balance: BigUInt, nonce: Int) {
        self.balance = balance
        self.nonce = nonce

        super.init()
    }

    required init(row: Row) throws {
        balance = row[Columns.balance]
        nonce = row[Columns.nonce]

        try super.init(row: row)
    }

    // MARK: Overridden Functions

    override public func encode(to container: inout PersistenceContainer) throws {
        container[Columns.primaryKey] = primaryKey
        container[Columns.balance] = balance
        container[Columns.nonce] = nonce
    }
}

// MARK: Equatable

extension AccountState: Equatable {
    public static func == (lhs: AccountState, rhs: AccountState) -> Bool {
        lhs.balance == rhs.balance && lhs.nonce == lhs.nonce
    }
}
