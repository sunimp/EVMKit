//
//  InternalTransactionSyncer.swift
//  EvmKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import BigInt

// MARK: - InternalTransactionSyncer

class InternalTransactionSyncer {
    private let provider: ITransactionProvider
    private let storage: TransactionStorage

    init(provider: ITransactionProvider, storage: TransactionStorage) {
        self.provider = provider
        self.storage = storage
    }

    private func handle(transactions: [ProviderInternalTransaction]) {
        guard !transactions.isEmpty else {
            return
        }

        let internalTransactions = transactions.map { tx in
            InternalTransaction(
                hash: tx.hash,
                blockNumber: tx.blockNumber,
                from: tx.from,
                to: tx.to,
                value: tx.value,
                traceId: tx.traceId
            )
        }

        storage.save(internalTransactions: internalTransactions)
    }
}

// MARK: ITransactionSyncer

extension InternalTransactionSyncer: ITransactionSyncer {
    func transactions() async throws -> ([Transaction], Bool) {
        let lastBlockNumber = storage.lastInternalTransaction()?.blockNumber ?? 0
        let initial = lastBlockNumber == 0

        do {
            let transactions = try await provider.internalTransactions(startBlock: lastBlockNumber + 1)

            handle(transactions: transactions)

            let array = transactions.map { tx in
                Transaction(
                    hash: tx.hash,
                    timestamp: tx.timestamp,
                    isFailed: false,
                    blockNumber: tx.blockNumber
                )
            }

            return (array, initial)
        } catch {
            return ([], initial)
        }
    }
}
