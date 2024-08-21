//
//  AddressProtocol.swift
//  EvmKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

public protocol AddressProtocol: CustomStringConvertible {
    /// Validates that the raw data is a valid address.
    static func isValid(data: Data) -> Bool

    /// Validates that the string is a valid address.
    static func isValid(string: String) -> Bool

    /// Raw representation of the address.
    var data: Data { get }

    /// Creates a address from a string representation.
    init?(string: String)

    /// Creates a address from a raw representation.
    init?(data: Data)
}
