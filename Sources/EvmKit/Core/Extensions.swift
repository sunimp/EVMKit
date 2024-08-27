//
//  BigUInt.swift
//  EvmKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import BigInt
import GRDB

extension BigUInt: DatabaseValueConvertible {
    public var databaseValue: DatabaseValue {
        description.databaseValue
    }

    public static func fromDatabaseValue(_ dbValue: DatabaseValue) -> BigUInt? {
        if case DatabaseValue.Storage.string(let value) = dbValue.storage {
            return BigUInt(value)
        }

        return nil
    }
}
