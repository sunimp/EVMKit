//
//  TransactionSigner.swift
//
//  Created by Sun on 2019/3/27.
//

import Foundation

import BigInt
import WWCryptoKit

class TransactionSigner {
    // MARK: Properties

    private let chainID: Int
    private let privateKey: Data

    // MARK: Lifecycle

    init(chain: Chain, privateKey: Data) {
        chainID = chain.id
        self.privateKey = privateKey
    }

    // MARK: Functions

    func sign(rawTransaction: RawTransaction) throws -> Data {
        switch rawTransaction.gasPrice {
        case let .legacy(legacyGasPrice):
            try signEip155(rawTransaction: rawTransaction, legacyGasPrice: legacyGasPrice)
        case let .eip1559(maxFeePerGas, maxPriorityFeePerGas):
            try signEip1559(
                rawTransaction: rawTransaction,
                maxFeePerGas: maxFeePerGas,
                maxPriorityFeePerGas: maxPriorityFeePerGas
            )
        }
    }

    func signEip155(rawTransaction: RawTransaction, legacyGasPrice: Int) throws -> Data {
        var toEncode: [Any] = [
            rawTransaction.nonce,
            legacyGasPrice,
            rawTransaction.gasLimit,
            rawTransaction.to.raw,
            rawTransaction.value,
            rawTransaction.data,
        ]

        if chainID != 0 {
            toEncode.append(contentsOf: [chainID, 0, 0]) // EIP155
        }

        let encodedData = RLP.encode(toEncode)
        let rawTransactionHash = Crypto.sha3(encodedData)

        return try Crypto.ellipticSign(rawTransactionHash, privateKey: privateKey)
    }

    func signEip1559(rawTransaction: RawTransaction, maxFeePerGas: Int, maxPriorityFeePerGas: Int) throws -> Data {
        let toEncode: [Any] = [
            chainID,
            rawTransaction.nonce,
            maxPriorityFeePerGas,
            maxFeePerGas,
            rawTransaction.gasLimit,
            rawTransaction.to.raw,
            rawTransaction.value,
            rawTransaction.data,
            [],
        ]

        let encodedData = RLP.encode(toEncode)
        let rawTransactionHash = Crypto.sha3(Data([0x02]) + encodedData)

        return try Crypto.ellipticSign(rawTransactionHash, privateKey: privateKey)
    }

    func signature(rawTransaction: RawTransaction) throws -> Signature {
        let signatureData: Data = try sign(rawTransaction: rawTransaction)

        switch rawTransaction.gasPrice {
        case .legacy:
            return signatureLegacy(from: signatureData)
        case .eip1559:
            return signatureEip1559(from: signatureData)
        }
    }

    func signatureLegacy(from data: Data) -> Signature {
        Signature(
            v: Int(data[64]) + (chainID == 0 ? 27 : (35 + 2 * chainID)),
            r: BigUInt(data[..<32].ww.hex, radix: 16)!,
            s: BigUInt(data[32 ..< 64].ww.hex, radix: 16)!
        )
    }

    func signatureEip1559(from data: Data) -> Signature {
        Signature(
            v: Int(data[64]),
            r: BigUInt(data[..<32].ww.hex, radix: 16)!,
            s: BigUInt(data[32 ..< 64].ww.hex, radix: 16)!
        )
    }
}
