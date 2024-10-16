//
//  ContractEvent.swift
//  EVMKit
//
//  Created by Sun on 2020/7/28.
//

import Foundation

import BigInt
import SWCryptoKit

// MARK: - ContractEvent

public struct ContractEvent {
    // MARK: Properties

    private let name: String
    private let arguments: [Argument]

    // MARK: Computed Properties

    public var signature: Data {
        let argumentTypes = arguments.map(\.type).joined(separator: ",")
        let structure = "\(name)(\(argumentTypes))"
        return Crypto.sha3(structure.data(using: .ascii)!)
    }

    // MARK: Lifecycle

    public init(name: String, arguments: [Argument] = []) {
        self.name = name
        self.arguments = arguments
    }
}

// MARK: ContractEvent.Argument

extension ContractEvent {
    public enum Argument {
        case uint256
        case uint256Array
        case address

        // MARK: Computed Properties

        public var type: String {
            switch self {
            case .uint256: "uint256"
            case .uint256Array: "uint256[]"
            case .address: "address"
            }
        }
    }
}
