//
//  EthereumTransactionSyncer.swift
//  EvmKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import BigInt

// MARK: - EthereumTransactionSyncer

class EthereumTransactionSyncer {
    private let syncerID = "ethereum-transaction-syncer"

    private let provider: ITransactionProvider
    private let storage: TransactionSyncerStateStorage

    init(provider: ITransactionProvider, storage: TransactionSyncerStateStorage) {
        self.provider = provider
        self.storage = storage
    }

    private func handle(providerTransactions: [ProviderTransaction]) {
        guard let maxBlockNumber = providerTransactions.map(\.blockNumber).max() else {
            return
        }

        let syncerState = TransactionSyncerState(syncerID: syncerID, lastBlockNumber: maxBlockNumber)
        try? storage.save(syncerState: syncerState)
    }
}

// MARK: ITransactionSyncer

extension EthereumTransactionSyncer: ITransactionSyncer {
    func transactions() async throws -> ([Transaction], Bool) {
        let lastBlockNumber = (try? storage.syncerState(syncerID: syncerID))?.lastBlockNumber ?? 0
        let initial = lastBlockNumber == 0

        do {
            let transactions = try await provider.transactions(startBlock: lastBlockNumber + 1)

            handle(providerTransactions: transactions)
            
            let array = transactions.map { tx -> Transaction in
                let isFailed: Bool =
                if let status = tx.txReceiptStatus {
                    status != 1
                } else if let isError = tx.isError {
                    isError != 0
                } else if let gasUsed = tx.gasUsed {
                    tx.gasLimit == gasUsed
                } else {
                    false
                }

                return Transaction(
                    hash: tx.hash,
                    timestamp: tx.timestamp,
                    isFailed: isFailed,
                    blockNumber: tx.blockNumber,
                    transactionIndex: tx.transactionIndex,
                    from: tx.from,
                    to: tx.to,
                    value: tx.value,
                    input: tx.input,
                    nonce: tx.nonce,
                    gasPrice: tx.gasPrice,
                    gasUsed: tx.gasUsed
                )
            }

            return (array, initial)
        } catch {
            return ([], initial)
        }
    }
}
