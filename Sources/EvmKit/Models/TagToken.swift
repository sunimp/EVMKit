//
//  TagToken.swift
//  EvmKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

public struct TagToken {
    public let `protocol`: TransactionTag.TagProtocol
    public let contractAddress: Address?
}
