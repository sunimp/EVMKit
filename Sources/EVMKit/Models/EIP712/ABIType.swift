//
//  ABIType.swift
//  EVMKit
//
//  Created by Sun on 2021/6/16.
//

import Foundation

public indirect enum ABIType: Equatable, CustomStringConvertible {
    /// Unsigned integer with `0 < bits <= 256`, `bits % 8 == 0`
    case uint(bits: Int)

    /// Signed integer with `0 < bits <= 256`, `bits % 8 == 0`
    case int(bits: Int)

    /// Address, similar to `uint(bits: 160)`
    case address

    /// Boolean
    case bool

    /// Signed fixed-point decimal number of M bits, `8 <= M <= 256`, `M % 8 == 0`, and `0 < N <= 80`, which denotes the
    /// value `v` as `v / (10 ** N)`
    case fixed(Int, Int)

    /// Unsigned fixed-point decimal number of M bits, `8 <= M <= 256`, `M % 8 == 0`, and `0 < N <= 80`, which denotes
    /// the value `v` as `v / (10 ** N)`
    case ufixed(Int, Int)

    /// Binary type of `M` bytes, `0 < M <= 32`.
    case bytes(Int)

    /// An address (20 bytes) followed by a function selector (4 bytes). Encoded identical to `bytes(24)`.
    case function(Function)

    /// Fixed-length array of M elements, `M > 0`, of the given type.
    case array(ABIType, Int)

    /// Dynamic-sized byte sequence
    case dynamicBytes

    /// Dynamic-sized string
    case string

    /// Variable-length array of elements of the given type
    case dynamicArray(ABIType)

    /// Tuple consisting of elements of the given types
    case tuple([ABIType])

    // MARK: Computed Properties

    /// Type description
    ///
    /// This is the string as required for function selectors
    public var description: String {
        switch self {
        case let .uint(bits):
            "uint\(bits)"
        case let .int(bits):
            "int\(bits)"
        case .address:
            "address"
        case .bool:
            "bool"
        case let .fixed(m, n):
            "fixed\(m)x\(n)"
        case let .ufixed(m, n):
            "ufixed\(m)x\(n)"
        case let .bytes(size):
            "bytes\(size)"
        case let .function(f):
            f.description
        case let .array(type, size):
            "\(type)[\(size)]"
        case .dynamicBytes:
            "bytes"
        case .string:
            "string"
        case let .dynamicArray(type):
            "\(type)[]"
        case let .tuple(types):
            types.reduce("") { $0 + $1.description }
        }
    }

    /// Whether the type is dynamic
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
        case let .function(f):
            f.parameters.contains(where: \.isDynamic)
        case let .tuple(array):
            array.contains(where: \.isDynamic)
        }
    }
}
