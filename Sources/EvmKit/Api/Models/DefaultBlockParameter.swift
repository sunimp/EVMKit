//
//  DefaultBlockParameter.swift
//  EvmKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

// MARK: - DefaultBlockParameter

public enum DefaultBlockParameter {
    
    case blockNumber(value: Int)
    case earliest
    case latest
    case pending

    var raw: String {
        switch self {
        case .blockNumber(let value):
            "0x" + String(value, radix: 16)
        case .earliest:
            "earliest"
        case .latest:
            "latest"
        case .pending:
            "pending"
        }
    }
}

// MARK: CustomStringConvertible

extension DefaultBlockParameter: CustomStringConvertible {
    public var description: String {
        raw
    }
}
