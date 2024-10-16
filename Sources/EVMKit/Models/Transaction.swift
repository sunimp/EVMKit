//
//  Transaction.swift
//  EVMKit
//
//  Created by Sun on 2018/10/12.
//

import Foundation

import BigInt
import GRDB

public class Transaction: Record {
    // MARK: Nested Types

    enum Columns: String, ColumnExpression {
        case hash
        case timestamp
        case isFailed
        case blockNumber
        case transactionIndex
        case from
        case to
        case value
        case input
        case nonce
        case gasPrice
        case maxFeePerGas
        case maxPriorityFeePerGas
        case gasLimit
        case gasUsed
        case replacedWith
    }

    // MARK: Overridden Properties

    override public class var databaseTableName: String {
        "transactions"
    }

    // MARK: Properties

    public let hash: Data
    public let timestamp: Int
    public var isFailed: Bool

    public let blockNumber: Int?
    public let transactionIndex: Int?
    public let from: Address?
    public let to: Address?
    public let value: BigUInt?
    public let input: Data?
    public let nonce: Int?
    public let gasPrice: Int?
    public let maxFeePerGas: Int?
    public let maxPriorityFeePerGas: Int?
    public let gasLimit: Int?
    public let gasUsed: Int?

    public var replacedWith: Data?

    // MARK: Lifecycle

    public init(
        hash: Data,
        timestamp: Int,
        isFailed: Bool,
        blockNumber: Int? = nil,
        transactionIndex: Int? = nil,
        from: Address? = nil,
        to: Address? = nil,
        value: BigUInt? = nil,
        input: Data? = nil,
        nonce: Int? = nil,
        gasPrice: Int? = nil,
        maxFeePerGas: Int? = nil,
        maxPriorityFeePerGas: Int? = nil,
        gasLimit: Int? = nil,
        gasUsed: Int? = nil,
        replacedWith: Data? = nil
    ) {
        self.hash = hash
        self.timestamp = timestamp
        self.isFailed = isFailed
        self.blockNumber = blockNumber
        self.transactionIndex = transactionIndex
        self.from = from
        self.to = to
        self.value = value
        self.input = input
        self.nonce = nonce
        self.gasPrice = gasPrice
        self.maxFeePerGas = maxFeePerGas
        self.maxPriorityFeePerGas = maxPriorityFeePerGas
        self.gasLimit = gasLimit
        self.gasUsed = gasUsed
        self.replacedWith = replacedWith

        super.init()
    }

    required init(row: Row) throws {
        hash = row[Columns.hash]
        timestamp = row[Columns.timestamp]
        isFailed = row[Columns.isFailed]
        blockNumber = row[Columns.blockNumber]
        transactionIndex = row[Columns.transactionIndex]
        let fromRow: Data? = row[Columns.from]
        from = fromRow.map { Address(raw: $0) }
        let toRow: Data? = row[Columns.to]
        to = toRow.map { Address(raw: $0) }
        value = row[Columns.value]
        input = row[Columns.input]
        nonce = row[Columns.nonce]
        gasPrice = row[Columns.gasPrice]
        maxFeePerGas = row[Columns.maxFeePerGas]
        maxPriorityFeePerGas = row[Columns.maxPriorityFeePerGas]
        gasLimit = row[Columns.gasLimit]
        gasUsed = row[Columns.gasUsed]
        replacedWith = row[Columns.replacedWith]

        try super.init(row: row)
    }

    // MARK: Overridden Functions

    override public func encode(to container: inout PersistenceContainer) throws {
        container[Columns.hash] = hash
        container[Columns.timestamp] = timestamp
        container[Columns.isFailed] = isFailed
        container[Columns.blockNumber] = blockNumber
        container[Columns.transactionIndex] = transactionIndex
        container[Columns.from] = from?.raw
        container[Columns.to] = to?.raw
        container[Columns.value] = value
        container[Columns.input] = input
        container[Columns.nonce] = nonce
        container[Columns.gasPrice] = gasPrice
        container[Columns.maxFeePerGas] = maxFeePerGas
        container[Columns.maxPriorityFeePerGas] = maxPriorityFeePerGas
        container[Columns.gasLimit] = gasLimit
        container[Columns.gasUsed] = gasUsed
        container[Columns.replacedWith] = replacedWith
    }
}
