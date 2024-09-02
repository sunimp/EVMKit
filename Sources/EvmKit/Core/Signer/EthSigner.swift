//
//  EthSigner.swift
//
//  Created by Sun on 2021/6/16.
//

import Foundation

import BigInt
import WWCryptoKit

class EthSigner {
    // MARK: Properties

    private let privateKey: Data

    // MARK: Lifecycle

    init(privateKey: Data) {
        self.privateKey = privateKey
    }

    // MARK: Functions

    public func sign(message: Data, isLegacy: Bool = false) throws -> Data {
        try Crypto.ellipticSign(isLegacy ? message : prefixed(message: message), privateKey: privateKey)
    }

    func sign(eip712TypedData: EIP712TypedData) throws -> Data {
        let signHash = try eip712TypedData.signHash()
        return try Crypto.ellipticSign(signHash, privateKey: privateKey)
    }

    private func prefixed(message: Data) -> Data {
        let prefix = "\u{0019}Ethereum Signed Message:\n\(message.count)"

        guard let prefixData = prefix.data(using: .utf8) else {
            return message
        }

        return Crypto.sha3(prefixData + message)
    }
}
