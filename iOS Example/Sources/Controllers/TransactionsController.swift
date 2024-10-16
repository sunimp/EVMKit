//
//  TransactionsController.swift
//  EVMKit-Example
//
//  Created by Sun on 2024/8/21.
//

import UIKit
import Combine

import UIExtensions

class TransactionsController: UITableViewController {
    private let limit = 20

    private let adapter: EthereumAdapter = Manager.shared.adapter
    private var cancellables = Set<AnyCancellable>()

    private var transactions = [TransactionRecord]()
    private var loading = false

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Transactions"

        tableView.registerCell(forClass: TransactionCell.self)
        tableView.tableFooterView = UIView()
        tableView.separatorInset = .zero

        adapter.lastBlockHeightPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)

        adapter.transactionsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.onTransactionsUpdated()
            }
            .store(in: &cancellables)

        loadNext()
    }

    private func onTransactionsUpdated() {
        transactions = []
        loading = false
        loadNext()
    }

    private func loadNext() {
        guard !loading else {
            return
        }

        loading = true

        let transactions = adapter.transactions(from: transactions.last?.transactionHashData, limit: limit)
        onLoad(transactions: transactions)
    }

    private func onLoad(transactions: [TransactionRecord]) {
        self.transactions.append(contentsOf: transactions)

        tableView.reloadData()

        if transactions.count == limit {
            loading = false
        }
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        transactions.count
    }

    override func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        250
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.dequeueReusableCell(withIdentifier: String(describing: TransactionCell.self), for: indexPath)
    }

    override func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? TransactionCell {
            cell.bind(transaction: transactions[indexPath.row], coin: adapter.coin, lastBlockHeight: adapter.lastBlockHeight)
        }

        if indexPath.row > transactions.count - 3 {
            loadNext()
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let transaction = transactions[indexPath.row]

        UIPasteboard.general.string = transaction.transactionHash

        let alert = UIAlertController(title: "Success", message: "Transaction Hash copied", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true)

        tableView.deselectRow(at: indexPath, animated: true)
    }
}
