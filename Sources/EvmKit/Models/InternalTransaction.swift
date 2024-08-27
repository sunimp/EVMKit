//
//  InternalTransaction.swift
//  EvmKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import BigInt
import GRDB

public class InternalTransaction: Record {
    public let hash: Data
    public let blockNumber: Int
    public let from: Address
    public let to: Address
    public let value: BigUInt
    public let traceID: String

    init(hash: Data, blockNumber: Int, from: Address, to: Address, value: BigUInt, traceID: String) {
        self.hash = hash
        self.blockNumber = blockNumber
        self.from = from
        self.to = to
        self.value = value
        self.traceID = traceID

        super.init()
    }

    override public class var databaseTableName: String {
        "internalTransactions"
    }

    enum Columns: String, ColumnExpression, CaseIterable {
        case hash
        case blockNumber
        case from
        case to
        case value
        case traceID
    }

    required init(row: Row) throws {
        hash = row[Columns.hash]
        blockNumber = row[Columns.blockNumber]
        from = Address(raw: row[Columns.from])
        to = Address(raw: row[Columns.to])
        value = row[Columns.value]
        traceID = row[Columns.traceID]

        try super.init(row: row)
    }

    override public func encode(to container: inout PersistenceContainer) throws {
        container[Columns.hash] = hash
        container[Columns.blockNumber] = blockNumber
        container[Columns.from] = from.raw
        container[Columns.to] = to.raw
        container[Columns.value] = value
        container[Columns.traceID] = traceID
    }
}
