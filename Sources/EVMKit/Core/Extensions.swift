//
//  Extensions.swift
//  EVMKit
//
//  Created by Sun on 2018/12/18.
//

import Foundation

import BigInt
import GRDB

#if compiler(>=6)
extension BigUInt: @retroactive DatabaseValueConvertible { }
#else
extension BigUInt: DatabaseValueConvertible { }
#endif
    
extension BigUInt {

    public var databaseValue: DatabaseValue {
        description.databaseValue
    }

    public static func fromDatabaseValue(_ dbValue: DatabaseValue) -> BigUInt? {
        if case let DatabaseValue.Storage.string(value) = dbValue.storage {
            return BigUInt(value)
        }

        return nil
    }
}
