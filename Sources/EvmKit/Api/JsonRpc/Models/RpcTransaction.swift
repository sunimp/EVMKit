//
//  RpcTransaction.swift
//
//  Created by Sun on 2020/9/24.
//

import Foundation

import BigInt
import ObjectMapper
import WWExtensions

// MARK: - RpcTransaction

public class RpcTransaction: ImmutableMappable {
    // MARK: Properties

    public let hash: Data
    public let nonce: Int
    public let from: Address
    public var to: Address?
    public let value: BigUInt
    public let gasPrice: Int
    public let maxFeePerGas: Int?
    public let maxPriorityFeePerGas: Int?
    public let gasLimit: Int
    public let input: Data
    public var blockHash: Data?
    public var blockNumber: Int?
    public var transactionIndex: Int?

    // MARK: Lifecycle

    public required init(map: Map) throws {
        hash = try map.value("hash", using: HexDataTransform())
        nonce = try map.value("nonce", using: HexIntTransform())
        from = try map.value("from", using: HexAddressTransform())
        to = try? map.value("to", using: HexAddressTransform())
        value = try map.value("value", using: HexBigUIntTransform())
        gasPrice = try map.value("gasPrice", using: HexIntTransform())
        maxFeePerGas = try? map.value("maxFeePerGas", using: HexIntTransform())
        maxPriorityFeePerGas = try? map.value("maxPriorityFeePerGas", using: HexIntTransform())
        gasLimit = try map.value("gas", using: HexIntTransform())
        input = try map.value("input", using: HexDataTransform())
        blockHash = try? map.value("blockHash", using: HexDataTransform())
        blockNumber = try? map.value("blockNumber", using: HexIntTransform())
        transactionIndex = try? map.value("transactionIndex", using: HexIntTransform())
    }
}

// MARK: CustomStringConvertible

extension RpcTransaction: CustomStringConvertible {
    public var description: String {
        "[hash: \(hash.ww.hexString); nonce: \(nonce); blockHash: \(blockHash?.ww.hexString ?? "nil"); blockNumber: \(blockNumber.map { "\($0)" } ?? "nil"); transactionIndex: \(transactionIndex.map { "\($0)" } ?? "nil"); from: \(from.hex); to: \(to?.hex ?? "nil"); value: \(value); gasPrice: \(gasPrice); gas: \(gasLimit); input: \(input.ww.hex)]"
    }
}
