//
//  FullRpcTransaction.swift
//  EVMKit
//
//  Created by Sun on 2022/4/4.
//

import Foundation

public struct FullRpcTransaction {
    // MARK: Properties

    public let rpcTransaction: RpcTransaction
    public let rpcTransactionReceipt: RpcTransactionReceipt?
    public let rpcBlock: RpcBlock?
    public let providerInternalTransactions: [ProviderInternalTransaction]

    // MARK: Computed Properties

    private var failed: Bool {
        guard let receipt = rpcTransactionReceipt else {
            return false
        }

        if let status = receipt.status {
            return status == 0
        } else {
            return rpcTransaction.gasLimit == receipt.gasUsed
        }
    }

    // MARK: Lifecycle

    public init(
        rpcTransaction: RpcTransaction,
        rpcTransactionReceipt: RpcTransactionReceipt? = nil,
        rpcBlock: RpcBlock? = nil,
        providerInternalTransactions: [ProviderInternalTransaction] = []
    ) {
        self.rpcTransaction = rpcTransaction
        self.rpcTransactionReceipt = rpcTransactionReceipt
        self.rpcBlock = rpcBlock
        self.providerInternalTransactions = providerInternalTransactions
    }

    // MARK: Functions

    func transaction(timestamp: Int) -> Transaction {
        Transaction(
            hash: rpcTransaction.hash,
            timestamp: timestamp,
            isFailed: failed,
            blockNumber: rpcBlock?.number,
            transactionIndex: rpcTransactionReceipt?.transactionIndex,
            from: rpcTransaction.from,
            to: rpcTransaction.to,
            value: rpcTransaction.value,
            input: rpcTransaction.input,
            nonce: rpcTransaction.nonce,
            gasPrice: rpcTransaction.gasPrice,
            maxFeePerGas: rpcTransaction.maxFeePerGas,
            maxPriorityFeePerGas: rpcTransaction.maxPriorityFeePerGas,
            gasLimit: rpcTransaction.gasLimit,
            gasUsed: rpcTransactionReceipt?.gasUsed
        )
    }
}
