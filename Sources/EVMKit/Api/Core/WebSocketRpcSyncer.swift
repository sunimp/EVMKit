//
//  WebSocketRpcSyncer.swift
//  EVMKit
//
//  Created by Sun on 2020/9/18.
//

import Foundation

import BigInt
import SWToolKit

// MARK: - WebSocketRpcSyncer

class WebSocketRpcSyncer {
    // MARK: Nested Types

    struct RpcHandler {
        let onSuccess: (JsonRpcResponse) -> Void
        let onError: (Error) -> Void
    }

    typealias SubscriptionHandler = (RpcSubscriptionResponse) -> Void

    // MARK: Properties

    weak var delegate: IRpcSyncerDelegate?

    private let rpcSocket: IRpcWebSocket
    private var logger: Logger?

    private var currentRpcID = 0
    private var rpcHandlers = [Int: RpcHandler]()
    private var subscriptionHandlers = [String: SubscriptionHandler]()

    private let queue = DispatchQueue(label: "com.sunimp.evm-kit.web-socket-rpc-syncer", qos: .userInitiated)

    // MARK: Computed Properties

    private(set) var state: SyncerState = .notReady(error: Kit.SyncError.notStarted) {
        didSet {
            if state != oldValue {
                delegate?.didUpdate(state: state)
            }
        }
    }

    private var nextRpcID: Int {
        currentRpcID += 1
        return currentRpcID
    }

    // MARK: Lifecycle

    private init(rpcSocket: IRpcWebSocket, logger: Logger? = nil) {
        self.rpcSocket = rpcSocket
        self.logger = logger
    }

    // MARK: Functions

    func send<T>(rpc: JsonRpc<T>, onSuccess: @escaping (T) -> Void, onError: @escaping (Error) -> Void) -> Int? {
        queue.sync { [weak self] in
            do {
                return try self?._send(
                    rpc: rpc,
                    handler: RpcHandler(
                        onSuccess: { response in
                            do {
                                try onSuccess(rpc.parse(response: response))
                            } catch {
                                onError(error)
                            }
                        },
                        onError: onError
                    )
                )
            } catch {
                onError(error)
                return nil
            }
        }
    }

    func subscribe<T>(
        subscription: RpcSubscription<T>,
        onSuccess: @escaping () -> Void,
        onError: @escaping (Error) -> Void,
        successHandler: @escaping (T) -> Void,
        errorHandler: @escaping (Error) -> Void
    ) {
        _ = send(
            rpc: SubscribeJsonRpc(params: subscription.params),
            onSuccess: { [weak self] subscriptionID in
                self?.subscriptionHandlers[subscriptionID] = { response in
                    do {
                        try successHandler(subscription.parse(result: response.params.result))
                    } catch {
                        errorHandler(error)
                    }
                }
                onSuccess()
            },
            onError: onError
        )
    }

    private func _send(rpc: JsonRpc<some Any>, handler: RpcHandler) throws -> Int {
        let rpcID = nextRpcID

        try rpcSocket.send(rpc: rpc, rpcID: rpcID)

        rpcHandlers[rpcID] = handler

        return rpcID
    }

    private func cancel(rpcID: Int) {
        queue.async {
            let handler = self.rpcHandlers.removeValue(forKey: rpcID)
            handler?.onError(NetworkManager.TaskError())
        }
    }

    private func subscribeToNewHeads() {
        subscribe(
            subscription: NewHeadsRpcSubscription(),
            onSuccess: { },
            onError: { _ in
//                    self?.onFailSync(error: error)
            },
            successHandler: { [weak self] header in
                self?.delegate?.didUpdate(lastBlockHeight: header.number)
            },
            errorHandler: { [weak self] error in
                self?.logger?.error("NewHeads Handle Failed: \(error)")
            }
        )
    }
}

// MARK: IRpcWebSocketDelegate

extension WebSocketRpcSyncer: IRpcWebSocketDelegate {
    func didUpdate(socketState: WebSocketState) {
        if case let .notReady(error) = state, let syncError = error as? Kit.SyncError, syncError == .notStarted {
            // do not react to web socket state if syncer was stopped
            return
        }

        switch socketState {
        case .connecting:
            state = .preparing

        case .connected:
            state = .ready
            subscribeToNewHeads()

        case let .disconnected(error):
            queue.async { [weak self] in
                self?.rpcHandlers.values.forEach { handler in
                    handler.onError(error)
                }
                self?.rpcHandlers = [:]
                self?.subscriptionHandlers = [:]
            }

            state = .notReady(error: error)
        }
    }

    func didReceive(rpcResponse: JsonRpcResponse) {
        queue.async { [weak self] in
            let handler = self?.rpcHandlers.removeValue(forKey: rpcResponse.id)
            handler?.onSuccess(rpcResponse)
        }
    }

    func didReceive(subscriptionResponse: RpcSubscriptionResponse) {
        queue.async { [weak self] in
            self?.subscriptionHandlers[subscriptionResponse.params.subscriptionID]?(subscriptionResponse)
        }
    }
}

// MARK: IRpcSyncer

extension WebSocketRpcSyncer: IRpcSyncer {
    var source: String {
        "WebSocket \(rpcSocket.source)"
    }

    func start() {
        state = .preparing

        rpcSocket.start()
    }

    func stop() {
        state = .notReady(error: Kit.SyncError.notStarted)

        rpcSocket.stop()
    }

    func fetch<T>(rpc: JsonRpc<T>) async throws -> T {
        try Task.checkCancellation()

        var rpcID: Int?

        let onCancel = { [weak self] in
            if let rpcID {
                self?.cancel(rpcID: rpcID)
            }
        }

        return try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation { [weak self] continuation in
                rpcID = self?.send(
                    rpc: rpc,
                    onSuccess: { value in
                        continuation.resume(returning: value)
                    },
                    onError: { error in
                        continuation.resume(throwing: error)
                    }
                )
            }
        } onCancel: {
            onCancel()
        }
    }
}

extension WebSocketRpcSyncer {
    static func instance(socket: IWebSocket, logger: Logger? = nil) -> WebSocketRpcSyncer {
        let rpcSocket = RpcWebSocket(socket: socket, logger: logger)
        socket.delegate = rpcSocket

        let syncer = WebSocketRpcSyncer(rpcSocket: rpcSocket, logger: logger)
        rpcSocket.delegate = syncer

        return syncer
    }
}
