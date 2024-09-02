//
//  FeeHistory.swift
//
//  Created by Sun on 2022/2/9.
//

import Foundation

import ObjectMapper

public struct FeeHistory: ImmutableMappable {
    // MARK: Properties

    public let baseFeePerGas: [Int]
    public let gasUsedRatio: [Double]
    public let oldestBlock: Int
    public let reward: [[Int]]

    // MARK: Lifecycle

    public init(map: Map) throws {
        baseFeePerGas = try map.value("baseFeePerGas", using: HexIntTransform())
        gasUsedRatio = try map.value("gasUsedRatio")
        oldestBlock = try map.value("oldestBlock", using: HexIntTransform())
        reward = try map.value("reward", using: HexIntTransform())
    }
}
