//
//  TransactionBuilder.swift
//  EVMKit
//
//  Created by Sun on 2019/3/27.
//

import Foundation

import SWCryptoKit

// MARK: - TransactionBuilder

class TransactionBuilder {
    // MARK: Properties

    private let chainID: Int
    private let address: Address

    // MARK: Lifecycle

    init(chain: Chain, address: Address) {
        chainID = chain.id
        self.address = address
    }

    // MARK: Functions

    func transaction(rawTransaction: RawTransaction, signature: Signature) -> Transaction {
        let transactionHash = Crypto.sha3(encode(rawTransaction: rawTransaction, signature: signature))

        var maxFeePerGas: Int?
        var maxPriorityFeePerGas: Int?
        if case let .eip1559(max, priority) = rawTransaction.gasPrice {
            maxFeePerGas = max
            maxPriorityFeePerGas = priority
        }

        return Transaction(
            hash: transactionHash,
            timestamp: Int(Date().timeIntervalSince1970),
            isFailed: false,
            from: address,
            to: rawTransaction.to,
            value: rawTransaction.value,
            input: rawTransaction.data,
            nonce: rawTransaction.nonce,
            gasPrice: rawTransaction.gasPrice.max,
            maxFeePerGas: maxFeePerGas,
            maxPriorityFeePerGas: maxPriorityFeePerGas,
            gasLimit: rawTransaction.gasLimit
        )
    }

    func encode(rawTransaction: RawTransaction, signature: Signature?) -> Data {
        Self.encode(rawTransaction: rawTransaction, signature: signature, chainID: chainID)
    }
}

extension TransactionBuilder {
    static func encode(rawTransaction: RawTransaction, signature: Signature?, chainID: Int = 1) -> Data {
        let signatureArray: [Any?] = [
            signature?.v as Any,
            signature?.r as Any,
            signature?.s as Any,
        ].compactMap { $0 }

        switch rawTransaction.gasPrice {
        case let .legacy(legacyGasPrice):
            return RLP.encode([
                rawTransaction.nonce,
                legacyGasPrice,
                rawTransaction.gasLimit,
                rawTransaction.to.raw,
                rawTransaction.value,
                rawTransaction.data,
            ] + signatureArray)

        case let .eip1559(maxFeePerGas, maxPriorityFeePerGas):
            let encodedTransaction = RLP.encode([
                chainID,
                rawTransaction.nonce,
                maxPriorityFeePerGas,
                maxFeePerGas,
                rawTransaction.gasLimit,
                rawTransaction.to.raw,
                rawTransaction.value,
                rawTransaction.data,
                [],
            ] + signatureArray)

            return Data([0x02]) + encodedTransaction
        }
    }
}
