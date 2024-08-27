//
//  ABIError.swift
//  EvmKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

public enum ABIError: LocalizedError {
    case integerOverflow
    case invalidUTF8String
    case invalidNumberOfArguments
    case invalidArgumentType
    case functionSignatureMismatch

    public var errorDescription: String? {
        switch self {
        case .integerOverflow:
            NSLocalizedString("Integer overflow", comment: "ABI encoder error")
        case .invalidUTF8String:
            NSLocalizedString("Can't encode string as UTF8", comment: "ABI encoder error")
        case .invalidNumberOfArguments:
            NSLocalizedString("Invalid number of arguments", comment: "ABI error description")
        case .invalidArgumentType:
            NSLocalizedString("Invalid argument type", comment: "ABI error description")
        case .functionSignatureMismatch:
            NSLocalizedString("Function signature mismatch", comment: "ABI error description")
        }
    }
}
