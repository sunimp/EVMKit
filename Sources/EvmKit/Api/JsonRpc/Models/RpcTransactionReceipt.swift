//
//  RpcTransactionReceipt.swift
//
//  Created by Sun on 2020/9/24.
//

import Foundation

import BigInt
import ObjectMapper
import WWExtensions

// MARK: - RpcTransactionReceipt

public class RpcTransactionReceipt: ImmutableMappable {
    // MARK: Properties

    public let transactionHash: Data
    public let transactionIndex: Int
    public let blockHash: Data
    public let blockNumber: Int
    public let from: Address
    public var to: Address?
    public let effectiveGasPrice: Int
    public let cumulativeGasUsed: Int
    public let gasUsed: Int
    public var contractAddress: Data?
    public let logs: [TransactionLog]
    public let logsBloom: Data

    public var root: Data?
    public var status: Int?

    // MARK: Lifecycle

    public required init(map: Map) throws {
        transactionHash = try map.value("transactionHash", using: HexDataTransform())
        transactionIndex = try map.value("transactionIndex", using: HexIntTransform())
        blockHash = try map.value("blockHash", using: HexDataTransform())
        blockNumber = try map.value("blockNumber", using: HexIntTransform())
        from = try map.value("from", using: HexAddressTransform())
        to = try? map.value("to", using: HexAddressTransform())
        effectiveGasPrice = (try? map.value("effectiveGasPrice", using: HexIntTransform())) ?? 0
        cumulativeGasUsed = try map.value("cumulativeGasUsed", using: HexIntTransform())
        gasUsed = try map.value("gasUsed", using: HexIntTransform())
        contractAddress = try? map.value("contractAddress", using: HexDataTransform())
        logs = try map.value("logs")
        logsBloom = try map.value("logsBloom", using: HexDataTransform())

        root = try? map.value("root", using: HexDataTransform())
        status = try? map.value("status", using: HexIntTransform())
    }
}

// MARK: CustomStringConvertible

extension RpcTransactionReceipt: CustomStringConvertible {
    public var description: String {
        "[transactionHash: \(transactionHash.ww.hexString); transactionIndex: \(transactionIndex); blockHash: \(blockHash); blockNumber: \(blockNumber); status: \(status.map { "\($0)" } ?? "nil")]"
    }
}
