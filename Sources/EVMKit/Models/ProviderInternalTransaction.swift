//
//  ProviderInternalTransaction.swift
//  EVMKit
//
//  Created by Sun on 2022/4/4.
//

import Foundation

import BigInt
import ObjectMapper

public struct ProviderInternalTransaction: ImmutableMappable {
    // MARK: Properties

    let hash: Data
    let blockNumber: Int
    let timestamp: Int
    let from: Address
    let to: Address
    let value: BigUInt
    let traceID: String

    // MARK: Computed Properties

    var internalTransaction: InternalTransaction {
        InternalTransaction(
            hash: hash,
            blockNumber: blockNumber,
            from: from,
            to: to,
            value: value,
            traceID: traceID
        )
    }

    // MARK: Lifecycle

    public init(map: Map) throws {
        hash = try map.value("hash", using: HexDataTransform())
        blockNumber = try map.value("blockNumber", using: StringIntTransform())
        timestamp = try map.value("timeStamp", using: StringIntTransform())
        from = try map.value("from", using: HexAddressTransform())
        to = try map.value("to", using: HexAddressTransform())
        value = try map.value("value", using: StringBigUIntTransform())
        traceID = try map.value("traceId")
    }
}
