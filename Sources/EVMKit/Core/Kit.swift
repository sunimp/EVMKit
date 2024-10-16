//
//  Kit.swift
//  EVMKit
//
//  Created by Sun on 2018/10/9.
//

import Combine
import Foundation

import BigInt
import HDWalletKit
import SWCryptoKit
import SWToolKit

// MARK: - Kit

public class Kit {
    // MARK: Static Properties

    public static let defaultGasLimit = 21000

    // MARK: Properties

    public let eip20Storage: EIP20Storage
    public let address: Address

    public let chain: Chain
    public let uniqueID: String
    public let transactionProvider: ITransactionProvider

    public let logger: Logger

    private var cancellables = Set<AnyCancellable>()
    private let defaultMinAmount: BigUInt = 1

    private let lastBlockHeightSubject = PassthroughSubject<Int, Never>()
    private let syncStateSubject = PassthroughSubject<SyncState, Never>()
    private let accountStateSubject = PassthroughSubject<AccountState, Never>()

    private let blockchain: IBlockchain
    private let transactionManager: TransactionManager
    private let transactionSyncManager: TransactionSyncManager
    private let decorationManager: DecorationManager
    private let state: EVMKitState

    // MARK: Lifecycle

    init(
        blockchain: IBlockchain,
        transactionManager: TransactionManager,
        transactionSyncManager: TransactionSyncManager,
        state: EVMKitState = EVMKitState(),
        address: Address,
        chain: Chain,
        uniqueID: String,
        transactionProvider: ITransactionProvider,
        decorationManager: DecorationManager,
        eip20Storage: EIP20Storage,
        logger: Logger
    ) {
        self.blockchain = blockchain
        self.transactionManager = transactionManager
        self.transactionSyncManager = transactionSyncManager
        self.state = state
        self.address = address
        self.chain = chain
        self.uniqueID = uniqueID
        self.transactionProvider = transactionProvider
        self.decorationManager = decorationManager
        self.eip20Storage = eip20Storage
        self.logger = logger

        state.accountState = blockchain.accountState
        state.lastBlockHeight = blockchain.lastBlockHeight

        transactionManager.fullTransactionsPublisher
            .sink { [weak self] _ in
                self?.blockchain.syncAccountState()
            }
            .store(in: &cancellables)
    }
}

/// Public API Extension
extension Kit {
    public var lastBlockHeight: Int? {
        state.lastBlockHeight
    }

    public var accountState: AccountState? {
        state.accountState
    }

    public var syncState: SyncState {
        blockchain.syncState
    }

    public var transactionsSyncState: SyncState {
        transactionSyncManager.state
    }

    public var receiveAddress: Address {
        address
    }

    public var lastBlockHeightPublisher: AnyPublisher<Int, Never> {
        lastBlockHeightSubject.eraseToAnyPublisher()
    }

    public var syncStatePublisher: AnyPublisher<SyncState, Never> {
        syncStateSubject.eraseToAnyPublisher()
    }

    public var transactionsSyncStatePublisher: AnyPublisher<SyncState, Never> {
        transactionSyncManager.statePublisher
    }

    public var accountStatePublisher: AnyPublisher<AccountState, Never> {
        accountStateSubject.eraseToAnyPublisher()
    }

    public var allTransactionsPublisher: AnyPublisher<([FullTransaction], Bool), Never> {
        transactionManager.fullTransactionsPublisher
    }

    public func start() {
        blockchain.start()
        transactionSyncManager.sync()
    }

    public func stop() {
        blockchain.stop()
    }

    public func refresh() {
        blockchain.refresh()
        transactionSyncManager.sync()
    }

    public func fetchTransaction(hash: Data) async throws -> FullTransaction {
        try await transactionManager.fetchFullTransaction(hash: hash)
    }

    public func transactionsPublisher(tagQueries: [TransactionTagQuery]) -> AnyPublisher<[FullTransaction], Never> {
        transactionManager.fullTransactionsPublisher(tagQueries: tagQueries)
    }

    public func transactions(
        tagQueries: [TransactionTagQuery],
        fromHash: Data? = nil,
        limit: Int? = nil
    )
        -> [FullTransaction] {
        transactionManager.fullTransactions(tagQueries: tagQueries, fromHash: fromHash, limit: limit)
    }

    public func pendingTransactions(tagQueries: [TransactionTagQuery]) -> [FullTransaction] {
        transactionManager.pendingFullTransactions(tagQueries: tagQueries)
    }

    public func transaction(hash: Data) -> FullTransaction? {
        transactionManager.fullTransaction(hash: hash)
    }

    public func fullTransactions(byHashes hashes: [Data]) -> [FullTransaction] {
        transactionManager.fullTransactions(byHashes: hashes)
    }

    public func fetchRawTransaction(
        transactionData: TransactionData,
        gasPrice: GasPrice,
        gasLimit: Int,
        nonce: Int? = nil
    ) async throws
        -> RawTransaction {
        try await fetchRawTransaction(
            address: transactionData.to,
            value: transactionData.value,
            transactionInput: transactionData.input,
            gasPrice: gasPrice,
            gasLimit: gasLimit,
            nonce: nonce
        )
    }

    public func fetchRawTransaction(
        address: Address,
        value: BigUInt,
        transactionInput: Data = Data(),
        gasPrice: GasPrice,
        gasLimit: Int,
        nonce: Int? = nil
    ) async throws
        -> RawTransaction {
        let resolvedNonce: Int =
            if let nonce {
                nonce
            } else {
                try await blockchain.nonce(defaultBlockParameter: .pending)
            }

        return RawTransaction(
            gasPrice: gasPrice,
            gasLimit: gasLimit,
            to: address,
            value: value,
            data: transactionInput,
            nonce: resolvedNonce
        )
    }

    public func nonce(defaultBlockParameter: DefaultBlockParameter) async throws -> Int {
        try await blockchain.nonce(defaultBlockParameter: defaultBlockParameter)
    }

    public func tagTokens() -> [TagToken] {
        transactionManager.tagTokens()
    }

    public func send(rawTransaction: RawTransaction, signature: Signature) async throws -> FullTransaction {
        let transaction = try await blockchain.send(rawTransaction: rawTransaction, signature: signature)
        let fullTransactions = transactionManager.handle(transactions: [transaction])
        return fullTransactions[0]
    }

    public var debugInfo: String {
        var lines = [String]()

        lines.append("ADDRESS: \(address.hex)")

        return lines.joined(separator: "\n")
    }

    public func fetchStorageAt(
        contractAddress: Address,
        positionData: Data,
        defaultBlockParameter: DefaultBlockParameter = .latest
    ) async throws
        -> Data {
        try await blockchain.getStorageAt(
            contractAddress: contractAddress,
            positionData: positionData,
            defaultBlockParameter: defaultBlockParameter
        )
    }

    public func fetchCall(
        contractAddress: Address,
        data: Data,
        defaultBlockParameter: DefaultBlockParameter = .latest
    ) async throws
        -> Data {
        try await blockchain.call(
            contractAddress: contractAddress,
            data: data,
            defaultBlockParameter: defaultBlockParameter
        )
    }

    public func fetchEstimateGas(to: Address?, amount: BigUInt, gasPrice: GasPrice) async throws -> Int {
        // without address - provide default gas limit
        guard let to else {
            return Kit.defaultGasLimit
        }

        // if amount is 0 - set default minimum amount
        let resolvedAmount: BigUInt = amount == 0 ? defaultMinAmount : amount

        return try await blockchain.estimateGas(
            to: to,
            amount: resolvedAmount,
            gasLimit: chain.gasLimit,
            gasPrice: gasPrice,
            data: nil
        )
    }

    public func fetchEstimateGas(to: Address?, amount: BigUInt?, gasPrice: GasPrice, data: Data?) async throws -> Int {
        try await blockchain.estimateGas(
            to: to,
            amount: amount,
            gasLimit: chain.gasLimit,
            gasPrice: gasPrice,
            data: data
        )
    }

    public func fetchEstimateGas(transactionData: TransactionData, gasPrice: GasPrice) async throws -> Int {
        try await fetchEstimateGas(
            to: transactionData.to,
            amount: transactionData.value,
            gasPrice: gasPrice,
            data: transactionData.input
        )
    }

    func fetch<T>(rpcRequest: JsonRpc<T>) async throws -> T {
        try await blockchain.fetch(rpcRequest: rpcRequest)
    }

    public func add(transactionSyncer: ITransactionSyncer) {
        transactionSyncManager.add(syncer: transactionSyncer)
    }

    public func add(methodDecorator: IMethodDecorator) {
        decorationManager.add(methodDecorator: methodDecorator)
    }

    public func add(eventDecorator: IEventDecorator) {
        decorationManager.add(eventDecorator: eventDecorator)
    }

    public func add(transactionDecorator: ITransactionDecorator) {
        decorationManager.add(transactionDecorator: transactionDecorator)
    }

    public func decorate(transactionData: TransactionData) -> TransactionDecoration? {
        decorationManager.decorateTransaction(from: address, transactionData: transactionData)
    }

    public func transferTransactionData(to: Address, value: BigUInt) -> TransactionData {
        transactionManager.etherTransferTransactionData(to: to, value: value)
    }

    public func statusInfo() -> [(String, Any)] {
        [
            ("Last Block Height", "\(state.lastBlockHeight.map { "\($0)" } ?? "N/A")"),
            ("Sync State", blockchain.syncState.description),
            ("Blockchain Source", blockchain.source),
            ("Transactions Source", "Infura.io, Etherscan.io"),
        ]
    }
}

// MARK: IBlockchainDelegate

extension Kit: IBlockchainDelegate {
    func onUpdate(lastBlockHeight: Int) {
        guard state.lastBlockHeight != lastBlockHeight else {
            return
        }

        state.lastBlockHeight = lastBlockHeight

        lastBlockHeightSubject.send(lastBlockHeight)
        transactionSyncManager.sync()
    }

    func onUpdate(accountState: AccountState) {
        guard state.accountState != accountState else {
            return
        }

        state.accountState = accountState
        accountStateSubject.send(accountState)
    }

    func onUpdate(syncState: SyncState) {
        syncStateSubject.send(syncState)
    }
}

extension Kit {
    public static func clear(exceptFor excludedFiles: [String]) throws {
        let fileManager = FileManager.default
        let fileURLs = try fileManager.contentsOfDirectory(at: dataDirectoryURL(), includingPropertiesForKeys: nil)

        for filename in fileURLs {
            if !excludedFiles.contains(where: { filename.lastPathComponent.contains($0) }) {
                try fileManager.removeItem(at: filename)
            }
        }
    }

    public static func instance(
        address: Address,
        chain: Chain,
        rpcSource: RpcSource,
        transactionSource: TransactionSource,
        walletID: String,
        minLogLevel: Logger.Level = .error
    ) throws
        -> Kit {
        let logger = Logger(minLogLevel: minLogLevel)
        let uniqueID = "\(walletID)-\(chain.id)"

        let networkManager = NetworkManager(logger: logger)

        let syncer: IRpcSyncer
        let reachabilityManager = ReachabilityManager()

        switch rpcSource {
        case let .http(urls, auth):
            let apiProvider = NodeApiProvider(networkManager: networkManager, urls: urls, auth: auth)
            syncer = ApiRpcSyncer(
                rpcApiProvider: apiProvider,
                reachabilityManager: reachabilityManager,
                syncInterval: chain.syncInterval
            )

        case let .webSocket(url, auth):
            let socket = WebSocket(url: url, reachabilityManager: reachabilityManager, auth: auth, logger: logger)
            syncer = WebSocketRpcSyncer.instance(socket: socket, logger: logger)
        }

        let transactionBuilder = TransactionBuilder(chain: chain, address: address)
        let transactionProvider: ITransactionProvider = transactionProvider(
            transactionSource: transactionSource,
            address: address,
            logger: logger
        )

        let storage: IApiStorage = try ApiStorage(
            databaseDirectoryURL: dataDirectoryURL(),
            databaseFileName: "api-\(uniqueID)"
        )
        let blockchain = RpcBlockchain.instance(
            address: address,
            storage: storage,
            syncer: syncer,
            transactionBuilder: transactionBuilder,
            logger: logger
        )

        let transactionStorage = try TransactionStorage(
            databaseDirectoryURL: dataDirectoryURL(),
            databaseFileName: "transactions-\(uniqueID)"
        )
        let transactionSyncerStateStorage = try TransactionSyncerStateStorage(
            databaseDirectoryURL: dataDirectoryURL(),
            databaseFileName: "transaction-syncer-states-\(uniqueID)"
        )

        let ethereumTransactionSyncer = EthereumTransactionSyncer(
            provider: transactionProvider,
            storage: transactionSyncerStateStorage
        )
        let internalTransactionSyncer = InternalTransactionSyncer(
            provider: transactionProvider,
            storage: transactionStorage
        )
        let decorationManager = DecorationManager(userAddress: address, storage: transactionStorage)
        let transactionManager = TransactionManager(
            userAddress: address,
            storage: transactionStorage,
            decorationManager: decorationManager,
            blockchain: blockchain,
            transactionProvider: transactionProvider
        )
        let transactionSyncManager = TransactionSyncManager(transactionManager: transactionManager)

        transactionSyncManager.add(syncer: ethereumTransactionSyncer)
        transactionSyncManager.add(syncer: internalTransactionSyncer)

        let eip20Storage = try EIP20Storage(
            databaseDirectoryURL: dataDirectoryURL(),
            databaseFileName: "eip20-\(uniqueID)"
        )

        let kit = Kit(
            blockchain: blockchain, transactionManager: transactionManager,
            transactionSyncManager: transactionSyncManager,
            address: address, chain: chain, uniqueID: uniqueID, transactionProvider: transactionProvider,
            decorationManager: decorationManager,
            eip20Storage: eip20Storage, logger: logger
        )

        blockchain.delegate = kit

        decorationManager.add(transactionDecorator: EthereumDecorator(address: address))

        return kit
    }

    private static func transactionProvider(
        transactionSource: TransactionSource,
        address: Address,
        logger: Logger
    )
        -> ITransactionProvider {
        switch transactionSource.type {
        case let .etherscan(apiBaseURL, _, apiKey):
            EtherscanTransactionProvider(baseURL: apiBaseURL, apiKey: apiKey, address: address, logger: logger)
        case let .custom(apiURL, _):
            CustomTransactionProvider(baseURL: apiURL, address: address, logger: logger)
        }
    }

    private static func dataDirectoryURL() throws -> URL {
        let fileManager = FileManager.default

        let url = try fileManager
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("ethereum-kit", isDirectory: true)

        try fileManager.createDirectory(at: url, withIntermediateDirectories: true)

        return url
    }
}

extension Kit {
    public static func sign(message: Data, privateKey: Data, isLegacy: Bool = false) throws -> Data {
        let ethSigner = EthSigner(privateKey: privateKey)
        return try ethSigner.sign(message: message, isLegacy: isLegacy)
    }

    public static func sign(message: Data, seed: Data, isLegacy: Bool = false) throws -> Data {
        let privateKey = try Signer.privateKey(seed: seed, chain: .ethereum)
        return try sign(message: message, privateKey: privateKey, isLegacy: isLegacy)
    }

    public static func call(
        networkManager: NetworkManager,
        rpcSource: RpcSource,
        contractAddress: Address,
        data: Data,
        defaultBlockParameter: DefaultBlockParameter = .latest
    ) async throws
        -> Data {
        let rpcApiProvider: IRpcApiProvider

        switch rpcSource {
        case let .http(urls, auth):
            rpcApiProvider = NodeApiProvider(networkManager: networkManager, urls: urls, auth: auth)
        case .webSocket:
            throw RpcSourceError.websocketNotSupported
        }

        let rpc = RpcBlockchain.callRpc(
            contractAddress: contractAddress,
            data: data,
            defaultBlockParameter: defaultBlockParameter
        )
        return try await rpcApiProvider.fetch(rpc: rpc)
    }

    public static func estimateGas(
        networkManager: NetworkManager,
        rpcSource: RpcSource,
        chain: Chain,
        from: Address,
        to: Address?,
        amount: BigUInt?,
        gasPrice: GasPrice,
        data: Data?
    ) async throws
        -> Int {
        try await RpcBlockchain.estimateGas(
            networkManager: networkManager,
            rpcSource: rpcSource,
            from: from,
            to: to,
            amount: amount,
            gasLimit: chain.gasLimit,
            gasPrice: gasPrice,
            data: data
        )
    }

    public static func estimateGas(
        networkManager: NetworkManager,
        rpcSource: RpcSource,
        chain: Chain,
        from: Address,
        transactionData: TransactionData,
        gasPrice: GasPrice
    ) async throws
        -> Int {
        try await estimateGas(
            networkManager: networkManager,
            rpcSource: rpcSource,
            chain: chain,
            from: from,
            to: transactionData.to,
            amount: transactionData.value,
            gasPrice: gasPrice,
            data: transactionData.input
        )
    }

    public static func nonceSingle(
        networkManager: NetworkManager,
        rpcSource: RpcSource,
        userAddress: Address,
        defaultBlockParameter: DefaultBlockParameter = .latest
    ) async throws
        -> Int {
        let request = GetTransactionCountJsonRpc(address: userAddress, defaultBlockParameter: defaultBlockParameter)
        return try await RpcBlockchain.call(networkManager: networkManager, rpcSource: rpcSource, rpcRequest: request)
    }
}

extension Kit {
    public enum KitError: Error {
        case weakReference
    }

    public enum SyncError: Error {
        case notStarted
        case noNetworkConnection
    }

    public enum SendError: Error {
        case noAccountState
    }

    public enum RpcSourceError: Error {
        case websocketNotSupported
    }
}
