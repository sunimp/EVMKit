//
//  Event.swift
//  EVMKit
//
//  Created by Sun on 2022/4/4.
//

import Foundation

import BigInt
import GRDB

public class Event: Record {
    // MARK: Nested Types

    enum Columns: String, ColumnExpression {
        case hash
        case blockNumber
        case contractAddress
        case from
        case to
        case value
        case tokenName
        case tokenSymbol
        case tokenDecimal
    }

    // MARK: Overridden Properties

    override public class var databaseTableName: String {
        "events"
    }

    // MARK: Properties

    public let hash: Data
    public let blockNumber: Int
    public let contractAddress: Address
    public let from: Address
    public let to: Address
    public let value: BigUInt
    public let tokenName: String
    public let tokenSymbol: String
    public let tokenDecimal: Int

    // MARK: Lifecycle

    public init(
        hash: Data,
        blockNumber: Int,
        contractAddress: Address,
        from: Address,
        to: Address,
        value: BigUInt,
        tokenName: String,
        tokenSymbol: String,
        tokenDecimal: Int
    ) {
        self.hash = hash
        self.blockNumber = blockNumber
        self.contractAddress = contractAddress
        self.from = from
        self.to = to
        self.value = value
        self.tokenName = tokenName
        self.tokenSymbol = tokenSymbol
        self.tokenDecimal = tokenDecimal

        super.init()
    }

    public required init(row: Row) throws {
        hash = row[Columns.hash]
        blockNumber = row[Columns.blockNumber]
        contractAddress = Address(raw: row[Columns.contractAddress])
        from = Address(raw: row[Columns.from])
        to = Address(raw: row[Columns.to])
        value = row[Columns.value]
        tokenName = row[Columns.tokenName]
        tokenSymbol = row[Columns.tokenSymbol]
        tokenDecimal = row[Columns.tokenDecimal]

        try super.init(row: row)
    }

    // MARK: Overridden Functions

    override public func encode(to container: inout PersistenceContainer) throws {
        container[Columns.hash] = hash
        container[Columns.blockNumber] = blockNumber
        container[Columns.contractAddress] = contractAddress.raw
        container[Columns.from] = from.raw
        container[Columns.to] = to.raw
        container[Columns.value] = value
        container[Columns.tokenName] = tokenName
        container[Columns.tokenSymbol] = tokenSymbol
        container[Columns.tokenDecimal] = tokenDecimal
    }
}
