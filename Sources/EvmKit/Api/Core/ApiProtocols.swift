//
//  ApiProtocols.swift
//  EvmKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import BigInt
import WWToolKit

// MARK: - IRpcApiProvider

protocol IRpcApiProvider {
    var source: String { get }
    func fetch<T>(rpc: JsonRpc<T>) async throws -> T
}

// MARK: - IApiStorage

protocol IApiStorage {
    var lastBlockHeight: Int? { get }
    func save(lastBlockHeight: Int)

    var accountState: AccountState? { get }
    func save(accountState: AccountState)
}

// MARK: - IRpcSyncer

protocol IRpcSyncer: AnyObject {
    var delegate: IRpcSyncerDelegate? { get set }

    var source: String { get }
    var state: SyncerState { get }

    func start()
    func stop()

    func fetch<T>(rpc: JsonRpc<T>) async throws -> T
}

// MARK: - IRpcSyncerDelegate

protocol IRpcSyncerDelegate: AnyObject {
    func didUpdate(state: SyncerState)
    func didUpdate(lastBlockHeight: Int)
}

// MARK: - IRpcWebSocket

protocol IRpcWebSocket: AnyObject {
    var delegate: IRpcWebSocketDelegate? { get set }
    var source: String { get }

    func start()
    func stop()

    func send<T>(rpc: JsonRpc<T>, rpcID: Int) throws
}

// MARK: - IRpcWebSocketDelegate

protocol IRpcWebSocketDelegate: AnyObject {
    func didUpdate(socketState: WebSocketState)
    func didReceive(rpcResponse: JsonRpcResponse)
    func didReceive(subscriptionResponse: RpcSubscriptionResponse)
}

// MARK: - SyncerState

enum SyncerState {
    case preparing
    case ready
    case notReady(error: Error)
}

// MARK: Equatable

extension SyncerState: Equatable {
    public static func == (lhs: SyncerState, rhs: SyncerState) -> Bool {
        switch (lhs, rhs) {
        case (.preparing, .preparing): true
        case (.ready, .ready): true
        case (.notReady(let lhsError), .notReady(let rhsError)): "\(lhsError)" == "\(rhsError)"
        default: false
        }
    }
}
