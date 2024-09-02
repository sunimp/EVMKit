//
//  DefaultBlockParameter.swift
//
//  Created by Sun on 2020/8/3.
//

import Foundation

// MARK: - DefaultBlockParameter

public enum DefaultBlockParameter {
    case blockNumber(value: Int)
    case earliest
    case latest
    case pending

    // MARK: Computed Properties

    var raw: String {
        switch self {
        case let .blockNumber(value):
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
