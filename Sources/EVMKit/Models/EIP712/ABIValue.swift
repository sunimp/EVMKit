//
//  ABIValue.swift
//  EVMKit
//
//  Created by Sun on 2021/6/16.
//

import Foundation

import BigInt

public indirect enum ABIValue: Equatable {
    /// Unsigned integer with `0 < bits <= 256`, `bits % 8 == 0`
    case uint(bits: Int, BigUInt)

    /// Signed integer with `0 < bits <= 256`, `bits % 8 == 0`
    case int(bits: Int, BigInt)

    /// Address, similar to `uint(bits: 160)`
    case address(EthereumAddress)

    /// Boolean
    case bool(Bool)

    /// Signed fixed-point decimal number of M bits, `8 <= M <= 256`, `M % 8 == 0`, and `0 < N <= 80`, which denotes the
    /// value `v` as `v / (10 ** N)`
    case fixed(bits: Int, Int, BigInt)

    /// Unsigned fixed-point decimal number of M bits, `8 <= M <= 256`, `M % 8 == 0`, and `0 < N <= 80`, which denotes
    /// the value `v` as `v / (10 ** N)`
    case ufixed(bits: Int, Int, BigUInt)

    /// Fixed-length bytes
    case bytes(Data)

    /// A function call
    case function(Function, [ABIValue])

    /// Fixed-length array where all values have the same type
    case array(ABIType, [ABIValue])

    /// Dynamic-sized byte sequence
    case dynamicBytes(Data)

    /// String
    case string(String)

    /// Variable-length array where all values have the same type
    case dynamicArray(ABIType, [ABIValue])

    /// Tuple
    case tuple([ABIValue])

    // MARK: Computed Properties

    /// Value type
    public var type: ABIType {
        switch self {
        case let .uint(bits, _):
            .uint(bits: bits)
        case let .int(bits, _):
            .int(bits: bits)
        case .address:
            .address
        case .bool:
            .bool
        case let .fixed(bits, scale, _):
            .fixed(bits, scale)
        case let .ufixed(bits, scale, _):
            .ufixed(bits, scale)
        case let .bytes(data):
            .bytes(data.count)
        case let .function(f, _):
            .function(f)
        case let .array(type, array):
            .array(type, array.count)
        case .dynamicBytes:
            .dynamicBytes
        case .string:
            .string
        case let .dynamicArray(type, _):
            .dynamicArray(type)
        case let .tuple(array):
            .tuple(array.map(\.type))
        }
    }

    /// Encoded length in bytes
    public var length: Int {
        switch self {
        case .uint,
             .int,
             .address,
             .bool,
             .fixed,
             .ufixed:
            return 32

        case let .bytes(data):
            return ((data.count + 31) / 32) * 32

        case let .function(_, args):
            return 4 + args.reduce(0) { $0 + $1.length }

        case let .array(_, array):
            return array.reduce(0) { $0 + $1.length }

        case let .dynamicBytes(data):
            return 32 + ((data.count + 31) / 32) * 32

        case let .string(string):
            let dataLength = string.data(using: .utf8)?.count ?? 0
            return 32 + ((dataLength + 31) / 32) * 32

        case let .dynamicArray(_, array):
            return 32 + array.reduce(0) { $0 + $1.length }

        case let .tuple(array):
            return array.reduce(0) { $0 + $1.length }
        }
    }

    /// Whether the value is dynamic
    public var isDynamic: Bool {
        switch self {
        case .uint,
             .int,
             .address,
             .bool,
             .fixed,
             .ufixed,
             .bytes,
             .array:
            false
        case .dynamicBytes,
             .string,
             .dynamicArray:
            true
        case let .function(_, array):
            array.contains(where: \.isDynamic)
        case let .tuple(array):
            array.contains(where: \.isDynamic)
        }
    }

    /// Returns the native (Swift) value for this ABI value.
    public var nativeValue: Any {
        switch self {
        case let .uint(_, value):
            value
        case let .int(_, value):
            value
        case let .address(value):
            value
        case let .bool(value):
            value
        case let .fixed(_, _, value):
            value
        case let .ufixed(_, _, value):
            value
        case let .bytes(value):
            value
        case let .function(f, args):
            (f, args)
        case let .array(_, array):
            array.map(\.nativeValue)
        case let .dynamicBytes(value):
            value
        case let .string(value):
            value
        case let .dynamicArray(_, array):
            array.map(\.nativeValue)
        case let .tuple(array):
            array.map(\.nativeValue)
        }
    }

    // MARK: Lifecycle

    /// Creates a value from `Any` and an `ABIType`.
    ///
    /// - Throws: `ABIError.invalidArgumentType` if a value doesn't match the expected type.
    public init(_ value: Any, type: ABIType) throws {
        switch (type, value) {
        case let (.uint(bits), value as Int):
            self = .uint(bits: bits, BigUInt(value))

        case let (.uint(bits), value as UInt):
            self = .uint(bits: bits, BigUInt(value))

        case let (.uint(bits), value as BigUInt):
            self = .uint(bits: bits, value)

        case let (.int(bits), value as Int):
            self = .int(bits: bits, BigInt(value))

        case let (.int(bits), value as BigInt):
            self = .int(bits: bits, value)

        case let (.address, address as EthereumAddress):
            self = .address(address)

        case let (.bool, value as Bool):
            self = .bool(value)

        case let (.fixed(bits, scale), value as BigInt):
            self = .fixed(bits: bits, scale, value)

        case let (.ufixed(bits, scale), value as BigUInt):
            self = .ufixed(bits: bits, scale, value)

        case let (.bytes(size), data as Data):
            if data.count > size {
                self = .bytes(data[..<size])
            } else {
                self = .bytes(data)
            }

        case let (.function(f), args as [Any]):
            self = try .function(f, f.castArguments(args))

        case let (.array(type, _), array as [Any]):
            self = try .array(type, array.map { try ABIValue($0, type: type) })

        case let (.dynamicBytes, data as Data):
            self = .dynamicBytes(data)

        case let (.dynamicBytes, string as String):
            self = .dynamicBytes(string.data(using: .utf8) ?? Data(Array(string.utf8)))

        case let (.string, string as String):
            self = .string(string)

        case let (.dynamicArray(type), array as [Any]):
            self = try .dynamicArray(type, array.map { try ABIValue($0, type: type) })

        case let (.tuple(types), array as [Any]):
            self = try .tuple(zip(types, array).map { try ABIValue($1, type: $0) })

        default:
            throw ABIError.invalidArgumentType
        }
    }
}
