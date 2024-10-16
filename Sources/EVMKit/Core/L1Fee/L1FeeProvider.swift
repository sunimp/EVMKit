//
//  L1FeeProvider.swift
//  EVMKit
//
//  Created by Sun on 2022/8/1.
//

import Foundation

import BigInt
import SWToolKit

// MARK: - L1FeeProvider

public class L1FeeProvider {
    // MARK: Properties

    private let evmKit: EVMKit.Kit
    private let contractAddress: Address

    // MARK: Lifecycle

    init(evmKit: EVMKit.Kit, contractAddress: Address) {
        self.evmKit = evmKit
        self.contractAddress = contractAddress
    }
}

extension L1FeeProvider {
    public func l1Fee(
        gasPrice: GasPrice,
        gasLimit: Int,
        to: Address,
        value: BigUInt,
        data: Data
    ) async throws
        -> BigUInt {
        let rawTransaction = RawTransaction(
            gasPrice: gasPrice,
            gasLimit: gasLimit,
            to: to,
            value: value,
            data: data,
            nonce: 1
        )
        let encoded = TransactionBuilder.encode(
            rawTransaction: rawTransaction,
            signature: nil,
            chainID: evmKit.chain.id
        )

        let methodData = L1FeeMethod(transaction: encoded).encodedABI()

        let data = try await evmKit.fetchCall(contractAddress: contractAddress, data: methodData)

        guard let value = BigUInt(data.prefix(32).sw.hex, radix: 16) else {
            throw L1FeeError.invalidHex
        }

        return value
    }
}

extension L1FeeProvider {
    class L1FeeMethod: ContractMethod {
        // MARK: Overridden Properties

        override var methodSignature: String {
            "getL1Fee(bytes)"
        }

        override var arguments: [Any] {
            [transaction]
        }

        // MARK: Properties

        let transaction: Data

        // MARK: Lifecycle

        init(transaction: Data) {
            self.transaction = transaction
        }
    }

    public enum L1FeeError: Error {
        case invalidHex
    }
}

extension L1FeeProvider {
    public static func instance(
        evmKit: EVMKit.Kit,
        contractAddress: Address,
        minLogLevel _: Logger.Level = .error
    )
        -> L1FeeProvider {
        L1FeeProvider(evmKit: evmKit, contractAddress: contractAddress)
    }
}
