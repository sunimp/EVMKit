//
//  Address.swift
//  EVMKit
//
//  Created by Sun on 2018/10/12.
//

import Foundation

import GRDB
import SWCryptoKit
import SWExtensions

// MARK: - Address

public struct Address {
    // MARK: Properties

    public let raw: Data

    // MARK: Computed Properties

    public var hex: String {
        raw.sw.hexString
    }

    public var eip55: String {
        EIP55.format(address: raw.sw.hex)
    }

    // MARK: Lifecycle

    public init(raw: Data) {
        if raw.count == 32 {
            self.raw = raw[12 ..< raw.count]
        } else {
            self.raw = raw
        }
    }

    public init(hex: String) throws {
        try Address.validate(address: hex)

        guard let data = hex.sw.hexData else {
            throw ValidationError.invalidHex
        }

        raw = data
    }
}

extension Address {
    private static func character(_ str: String, _ i: Int) -> String {
        String(str[str.index(str.startIndex, offsetBy: i)])
    }

    private static func isCheckSumAddress(hex: String) throws {
        let addressHash: String = Crypto.sha3(hex.lowercased().data(using: .ascii)!).sw.hex
        for i in 0 ..< 40 {
            let hashSymbol = character(addressHash, i)

            guard let int = Int(hashSymbol, radix: 16) else {
                throw ValidationError.invalidSymbols
            }
            if
                (int > 7 && character(hex, i).uppercased() != character(hex, i)) ||
                (int < 8 && character(hex, i).lowercased() != character(
                    hex,
                    i
                )) {
                throw ValidationError.invalidChecksum
            }
        }
    }

    private static func validate(address: String) throws {
        guard address.hasPrefix("0x") else {
            throw ValidationError.wrongAddressPrefix
        }
        let hex = String(address.dropFirst(2))
        guard hex.count == 40 else {
            throw ValidationError.invalidAddressLength
        }
        let decimalDigits = CharacterSet.decimalDigits
        let lowerCasedHex = decimalDigits.union(CharacterSet(charactersIn: "abcdef"))
        let upperCasedHex = decimalDigits.union(CharacterSet(charactersIn: "ABCDEF"))
        let mixedHex = decimalDigits.union(CharacterSet(charactersIn: "abcdefABCDEF"))
        guard mixedHex.isSuperset(of: CharacterSet(charactersIn: hex)) else {
            throw ValidationError.invalidSymbols
        }
        if
            lowerCasedHex.isSuperset(of: CharacterSet(charactersIn: hex)) || upperCasedHex
                .isSuperset(of: CharacterSet(charactersIn: hex)) {
            return
        } else {
            try isCheckSumAddress(hex: hex)
        }
    }
}

// MARK: CustomStringConvertible

extension Address: CustomStringConvertible {
    public var description: String {
        hex
    }
}

// MARK: Hashable

extension Address: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(raw)
    }

    public static func == (lhs: Address, rhs: Address) -> Bool {
        lhs.raw == rhs.raw
    }
}

// MARK: DatabaseValueConvertible

extension Address: DatabaseValueConvertible {
    public var databaseValue: DatabaseValue {
        raw.databaseValue
    }

    public static func fromDatabaseValue(_ dbValue: DatabaseValue) -> Address? {
        switch dbValue.storage {
        case let .blob(data):
            Address(raw: data)
        default:
            nil
        }
    }
}

// MARK: Address.ValidationError

extension Address {
    public enum ValidationError: Error {
        case invalidHex
        case invalidChecksum
        case invalidAddressLength
        case invalidSymbols
        case wrongAddressPrefix
    }
}
