//
//  ProviderEIP1155Transaction.swift
//  EVMKit
//
//  Created by Sun on 2022/8/24.
//

import Foundation

import BigInt
import ObjectMapper

public struct ProviderEIP1155Transaction: ImmutableMappable {
    // MARK: Properties

    public let blockNumber: Int
    public let timestamp: Int
    public let hash: Data
    public let nonce: Int
    public let blockHash: Data
    public let transactionIndex: Int
    public let gasLimit: Int
    public let gasPrice: Int
    public let gasUsed: Int
    public let cumulativeGasUsed: Int
    public let contractAddress: Address
    public let from: Address
    public let to: Address
    public let tokenID: BigUInt
    public let tokenValue: Int
    public let tokenName: String
    public let tokenSymbol: String

    // MARK: Lifecycle

    public init(map: Map) throws {
        blockNumber = try map.value("blockNumber", using: StringIntTransform())
        timestamp = try map.value("timeStamp", using: StringIntTransform())
        hash = try map.value("hash", using: HexDataTransform())
        nonce = try map.value("nonce", using: StringIntTransform())
        blockHash = try map.value("blockHash", using: HexDataTransform())
        transactionIndex = try map.value("transactionIndex", using: StringIntTransform())
        gasLimit = try map.value("gas", using: StringIntTransform())
        gasPrice = try map.value("gasPrice", using: StringIntTransform())
        gasUsed = try map.value("gasUsed", using: StringIntTransform())
        cumulativeGasUsed = try map.value("cumulativeGasUsed", using: StringIntTransform())
        contractAddress = try map.value("contractAddress", using: HexAddressTransform())
        from = try map.value("from", using: HexAddressTransform())
        to = try map.value("to", using: HexAddressTransform())
        tokenID = try map.value("tokenID", using: StringBigUIntTransform())
        tokenValue = try map.value("tokenValue", using: StringIntTransform())
        tokenName = try map.value("tokenName")
        tokenSymbol = try map.value("tokenSymbol")
    }
}
