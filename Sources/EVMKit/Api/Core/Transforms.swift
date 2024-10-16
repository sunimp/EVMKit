//
//  Transforms.swift
//  EVMKit
//
//  Created by Sun on 2020/9/23.
//

import Foundation

import BigInt
import ObjectMapper

// MARK: - HexIntTransform

struct HexIntTransform: TransformType {
    func transformFromJSON(_ value: Any?) -> Int? {
        guard let hexString = value as? String else {
            return nil
        }

        return Int(hexString.sw.stripHexPrefix(), radix: 16)
    }

    func transformToJSON(_: Int?) -> String? {
        fatalError("transformToJSON(_:) has not been implemented")
    }
}

// MARK: - HexStringTransform

struct HexStringTransform: TransformType {
    func transformFromJSON(_ value: Any?) -> String? {
        value as? String
    }

    func transformToJSON(_: String?) -> String? {
        fatalError("transformToJSON(_:) has not been implemented")
    }
}

// MARK: - HexDataArrayTransform

struct HexDataArrayTransform: TransformType {
    func transformFromJSON(_ value: Any?) -> [Data]? {
        guard let hexStrings = value as? [String] else {
            return nil
        }

        return hexStrings.compactMap(\.sw.hexData)
    }

    func transformToJSON(_: [Data]?) -> String? {
        fatalError("transformToJSON(_:) has not been implemented")
    }
}

// MARK: - HexDataTransform

struct HexDataTransform: TransformType {
    func transformFromJSON(_ value: Any?) -> Data? {
        guard let hexString = value as? String else {
            return nil
        }

        return hexString.sw.hexData
    }

    func transformToJSON(_: Data?) -> String? {
        fatalError("transformToJSON(_:) has not been implemented")
    }
}

// MARK: - HexAddressTransform

struct HexAddressTransform: TransformType {
    func transformFromJSON(_ value: Any?) -> Address? {
        guard let hexString = value as? String else {
            return nil
        }

        return try? Address(hex: hexString)
    }

    func transformToJSON(_: Address?) -> String? {
        fatalError("transformToJSON(_:) has not been implemented")
    }
}

// MARK: - HexBigUIntTransform

struct HexBigUIntTransform: TransformType {
    func transformFromJSON(_ value: Any?) -> BigUInt? {
        guard let hexString = value as? String else {
            return nil
        }

        return BigUInt(hexString.sw.stripHexPrefix(), radix: 16)
    }

    func transformToJSON(_: BigUInt?) -> String? {
        fatalError("transformToJSON(_:) has not been implemented")
    }
}

// MARK: - StringIntTransform

struct StringIntTransform: TransformType {
    func transformFromJSON(_ value: Any?) -> Int? {
        guard let string = value as? String else {
            return nil
        }

        return Int(string)
    }

    func transformToJSON(_: Int?) -> String? {
        fatalError("transformToJSON(_:) has not been implemented")
    }
}

// MARK: - StringBigUIntTransform

struct StringBigUIntTransform: TransformType {
    func transformFromJSON(_ value: Any?) -> BigUInt? {
        guard let string = value as? String else {
            return nil
        }

        return BigUInt(string)
    }

    func transformToJSON(_: BigUInt?) -> String? {
        fatalError("transformToJSON(_:) has not been implemented")
    }
}
