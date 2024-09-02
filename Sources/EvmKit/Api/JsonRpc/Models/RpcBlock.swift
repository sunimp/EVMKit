//
//  RpcBlock.swift
//
//  Created by Sun on 2019/4/10.
//

import Foundation

import BigInt
import ObjectMapper

public struct RpcBlock: ImmutableMappable {
    // MARK: Properties

    public let hash: Data
    public let number: Int
    public let timestamp: Int

    // MARK: Lifecycle

    public init(map: Map) throws {
        hash = try map.value("hash", using: HexDataTransform())
        number = try map.value("number", using: HexIntTransform())
        timestamp = try map.value("timestamp", using: HexIntTransform())
    }
}
