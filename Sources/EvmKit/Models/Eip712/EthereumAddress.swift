//
//  EthereumAddress.swift
//  EvmKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

/// Ethereum address.
public struct EthereumAddress: AddressProtocol, Hashable {
    public static let size = 20

    /// Validates that the raw data is a valid address.
    public static func isValid(data: Data) -> Bool {
        data.count == EthereumAddress.size
    }

    /// Validates that the string is a valid address.
    public static func isValid(string: String) -> Bool {
        guard let data = string.ww.hexData else {
            return false
        }
        return EthereumAddress.isValid(data: data)
    }

    /// Raw address bytes, length 20.
    public let data: Data

    /// EIP55 representation of the address.
    public let eip55String: String

    /// Creates an address with `Data`.
    ///
    /// - Precondition: data contains exactly 20 bytes
    public init?(data: Data) {
        if !EthereumAddress.isValid(data: data) {
            return nil
        }
        self.data = data
        eip55String = EthereumChecksum.computeString(for: data, type: .eip55)
    }

    /// Creates an address with an hexadecimal string representation.
    public init?(string: String) {
        guard let data = string.ww.hexData, EthereumAddress.isValid(data: data) else {
            return nil
        }
        self.init(data: data)
    }

    public var description: String {
        eip55String
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(data)
    }

    public static func == (lhs: EthereumAddress, rhs: EthereumAddress) -> Bool {
        lhs.data == rhs.data
    }
}
