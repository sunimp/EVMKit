//
//  RLPElement.swift
//  EVMKit
//
//  Created by Sun on 2019/2/13.
//

import Foundation

import BigInt

class RLPElement {
    // MARK: Properties

    let type: RLP.ElementType
    let lengthOfLengthBytes: Int
    let length: Int
    let dataValue: Data

    private let _listValue: [RLPElement]?

    // MARK: Lifecycle

    init(type: RLP.ElementType, length: Int, lengthOfLengthBytes: Int, dataValue: Data, listValue: [RLPElement]?) {
        self.type = type
        self.length = length
        self.lengthOfLengthBytes = lengthOfLengthBytes
        self.dataValue = dataValue
        _listValue = listValue
    }

    // MARK: Functions

    func listValue() throws -> [RLPElement] {
        guard type == .list, let list = _listValue else {
            throw RLP.DecodeError.invalidListValue
        }

        return list
    }

    func intValue() throws -> Int {
        guard type == .string else {
            throw RLP.DecodeError.invalidIntValue
        }

        if length == 0 {
            return 0
        }

        guard let uInt = UInt(dataValue.sw.hex, radix: 16) else {
            throw RLP.DecodeError.invalidIntValue
        }

        return Int(bitPattern: uInt)
    }

    func bigIntValue() throws -> BigUInt {
        guard type == .string else {
            throw RLP.DecodeError.invalidBigIntValue
        }

        if length == 0 {
            return 0
        }

        guard let bigInt = BigUInt(dataValue.sw.hex, radix: 16) else {
            throw RLP.DecodeError.invalidBigIntValue
        }

        return bigInt
    }

    func stringValue() throws -> String {
        guard type == .string else {
            throw RLP.DecodeError.invalidStringValue
        }

        if length == 0 {
            return ""
        }

        guard let str = String(data: dataValue, encoding: .utf8) else {
            throw RLP.DecodeError.invalidStringValue
        }

        return str
    }

    func isList() -> Bool {
        type == .list
    }
}
