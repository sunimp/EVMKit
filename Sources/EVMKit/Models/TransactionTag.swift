//
//  TransactionTag.swift
//  EVMKit
//
//  Created by Sun on 2021/6/3.
//

import Foundation

import GRDB

// MARK: - TransactionTag

public class TransactionTag {
    // MARK: Properties

    public let type: TagType
    public let `protocol`: TagProtocol?
    public let contractAddress: Address?
    public let addresses: [String]

    // MARK: Lifecycle

    public init(
        type: TagType,
        protocol: TagProtocol? = nil,
        contractAddress: Address? = nil,
        addresses: [String] = []
    ) {
        self.type = type
        self.protocol = `protocol`
        self.contractAddress = contractAddress
        self.addresses = addresses
    }

    // MARK: Functions

    public func conforms(tagQuery: TransactionTagQuery) -> Bool {
        if let type = tagQuery.type, self.type != type {
            return false
        }

        if let `protocol` = tagQuery.protocol, self.protocol != `protocol` {
            return false
        }

        if let contractAddress = tagQuery.contractAddress, self.contractAddress != contractAddress {
            return false
        }

        if let address = tagQuery.address?.lowercased(), !addresses.contains(address) {
            return false
        }

        return true
    }
}

// MARK: Hashable

extension TransactionTag: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(type)
        hasher.combine(`protocol`)
        hasher.combine(contractAddress)
        hasher.combine(addresses)
    }

    public static func == (lhs: TransactionTag, rhs: TransactionTag) -> Bool {
        lhs.type == rhs.type && lhs.protocol == rhs.protocol && lhs.contractAddress == rhs.contractAddress && lhs
            .addresses == rhs
            .addresses
    }
}

extension TransactionTag {
    public enum TagProtocol: String, DatabaseValueConvertible {
        case native
        case eip20
        case eip721
        case eip1155

        // MARK: Computed Properties

        public var databaseValue: DatabaseValue {
            rawValue.databaseValue
        }

        // MARK: Static Functions

        public static func fromDatabaseValue(_ dbValue: DatabaseValue) -> TagProtocol? {
            switch dbValue.storage {
            case let .string(string):
                TagProtocol(rawValue: string)
            default:
                nil
            }
        }
    }

    public enum TagType: String, DatabaseValueConvertible {
        case incoming
        case outgoing
        case approve
        case swap
        case contractCreation

        // MARK: Computed Properties

        public var databaseValue: DatabaseValue {
            rawValue.databaseValue
        }

        // MARK: Static Functions

        public static func fromDatabaseValue(_ dbValue: DatabaseValue) -> TagType? {
            switch dbValue.storage {
            case let .string(string):
                TagType(rawValue: string)
            default:
                nil
            }
        }
    }
}
