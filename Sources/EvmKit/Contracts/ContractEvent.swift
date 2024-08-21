//
//  ContractEvent.swift
//  EvmKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import BigInt
import WWCryptoKit

public struct ContractEvent {
    private let name: String
    private let arguments: [Argument]

    public init(name: String, arguments: [Argument] = []) {
        self.name = name
        self.arguments = arguments
    }

    public var signature: Data {
        let argumentTypes = arguments.map(\.type).joined(separator: ",")
        let structure = "\(name)(\(argumentTypes))"
        return Crypto.sha3(structure.data(using: .ascii)!)
    }
}

extension ContractEvent {
    
    public enum Argument {
        case uint256
        case uint256Array
        case address

        public var type: String {
            switch self {
            case .uint256: return "uint256"
            case .uint256Array: return "uint256[]"
            case .address: return "address"
            }
        }
    }
}
