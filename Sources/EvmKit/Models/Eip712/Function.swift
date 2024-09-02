//
//  Function.swift
//
//  Created by Sun on 2021/6/16.
//

import Foundation

import BigInt

public struct Function: Equatable, CustomStringConvertible {
    // MARK: Properties

    public var name: String
    public var parameters: [ABIType]

    // MARK: Computed Properties

    /// Function signature
    public var description: String {
        let descriptions = parameters.map(\.description).joined(separator: ",")
        return "\(name)(\(descriptions))"
    }

    // MARK: Lifecycle

    public init(name: String, parameters: [ABIType]) {
        self.name = name
        self.parameters = parameters
    }

    // MARK: Functions

    /// Casts the arguments into the appropriate types for this function.
    ///
    /// - Throws:
    ///   - `ABIError.invalidArgumentType` if a value doesn't match the expected type.
    ///   - `ABIError.invalidNumberOfArguments` if the number of values doesn't match the number of parameters.
    public func castArguments(_ values: [Any]) throws -> [ABIValue] {
        if values.count != parameters.count {
            throw ABIError.invalidNumberOfArguments
        }
        return try zip(parameters, values).map { try ABIValue($1, type: $0) }
    }
}
