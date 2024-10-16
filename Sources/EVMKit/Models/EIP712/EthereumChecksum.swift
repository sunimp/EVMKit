//
//  EthereumChecksum.swift
//  EVMKit
//
//  Created by Sun on 2021/6/16.
//

import Foundation

import SWCryptoKit

// MARK: - EthereumChecksumType

public enum EthereumChecksumType {
    case eip55
    case wanchain
}

// MARK: - EthereumChecksum

public enum EthereumChecksum {
    public static func computeString(for data: Data, type: EthereumChecksumType) -> String {
        let addressString = data.sw.hex
        let hashInput = addressString.data(using: .ascii)!
        let hash = Crypto.sha3(hashInput).sw.hex

        var string = "0x"
        for (a, h) in zip(addressString, hash) {
            switch (a, h) {
            case ("0", _),
                 ("1", _),
                 ("2", _),
                 ("3", _),
                 ("4", _),
                 ("5", _),
                 ("6", _),
                 ("7", _),
                 ("8", _),
                 ("9", _):
                string.append(a)

            case (_, "8"),
                 (_, "9"),
                 (_, "a"),
                 (_, "b"),
                 (_, "c"),
                 (_, "d"),
                 (_, "e"),
                 (_, "f"):
                switch type {
                case .eip55:
                    string.append(contentsOf: String(a).uppercased())
                case .wanchain:
                    string.append(contentsOf: String(a).lowercased())
                }

            default:
                switch type {
                case .eip55:
                    string.append(contentsOf: String(a).lowercased())
                case .wanchain:
                    string.append(contentsOf: String(a).uppercased())
                }
            }
        }

        return string
    }
}
