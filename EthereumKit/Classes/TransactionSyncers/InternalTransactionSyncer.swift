import RxSwift
import BigInt

class InternalTransactionSyncer: AbstractTransactionSyncer {
    private let provider: EtherscanTransactionProvider
    private let storage: ITransactionStorage
    private let scheduler = ConcurrentDispatchQueueScheduler(qos: .background)
    private var resync: Bool = false

    weak var listener: ITransactionSyncerListener?

    init(provider: EtherscanTransactionProvider, storage: ITransactionStorage) {
        self.provider = provider
        self.storage = storage

        super.init(id: "internal_transaction_syncer")
    }

    private func doSync(retry: Bool) {
        var single = provider.internalTransactionsSingle(startBlock: lastSyncBlockNumber + 1)

        if retry {
            single = single.retryWith(options: RetryOptions(mustRetry: { $0.isEmpty }), scheduler: scheduler)
        }

        single
                .observeOn(scheduler)
                .subscribe(
                        onSuccess: { [weak self] transactions in
                            guard let syncer = self else {
                                return
                            }

                            if !transactions.isEmpty {
                                syncer.storage.save(internalTransactions: transactions)

                                if let blockNumber = transactions.first?.blockNumber {
                                    syncer.update(lastSyncBlockNumber: blockNumber)
                                }

                                var notSyncedTransactions = [NotSyncedTransaction]()
                                var syncedTransactions = [FullTransaction]()

                                for etherscanTransaction in transactions {
                                    if let transaction = syncer.storage.transaction(hash: etherscanTransaction.hash) {
                                        syncedTransactions.append(transaction)
                                    } else {
                                        notSyncedTransactions.append(NotSyncedTransaction(hash: etherscanTransaction.hash))
                                    }
                                }

                                if !notSyncedTransactions.isEmpty {
                                    syncer.delegate.add(notSyncedTransactions: notSyncedTransactions)
                                }

                                if !syncedTransactions.isEmpty {
                                    syncer.listener?.onTransactionsSynced(fullTransactions: syncedTransactions)
                                }
                            }

                            if syncer.resync {
                                syncer.resync = false
                                syncer.doSync(retry: true)
                            } else {
                                syncer.state = .synced
                            }
                        },
                        onError: { [weak self] error in
                            self?.state = .notSynced(error: error)
                        }
                )
                .disposed(by: disposeBag)
    }

    private func sync(retry: Bool = false) {
        if state.syncing {
            if retry {
                resync = true
            }
            return
        }

        state = .syncing(progress: nil)
        doSync(retry: retry)
    }

    override func onEthereumSynced() {
        sync()
    }

    override func onUpdateAccountState(accountState: AccountState) {
        sync(retry: true)
    }

}