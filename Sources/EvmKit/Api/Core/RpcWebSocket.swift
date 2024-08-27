//
//  RpcWebSocket.swift
//  EvmKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import WWToolKit

// MARK: - RpcWebSocket

class RpcWebSocket {
    weak var delegate: IRpcWebSocketDelegate? = nil

    private let socket: IWebSocket
    private var logger: Logger? = nil

    init(socket: IWebSocket, logger: Logger? = nil) {
        self.socket = socket
        self.logger = logger
    }
}

// MARK: IRpcWebSocket

extension RpcWebSocket: IRpcWebSocket {
    var source: String {
        socket.source
    }

    func start() {
        socket.start()
    }

    func stop() {
        socket.stop()
    }

    func send(rpc: JsonRpc<some Any>, rpcID: Int) throws {
        let parameters = rpc.parameters(id: rpcID)
        let data = try JSONSerialization.data(withJSONObject: parameters)

        try socket.send(data: data, completionHandler: nil)

        logger?.debug("Send RPC: \(String(data: data, encoding: .utf8) ?? "nil")")
    }
}

// MARK: IWebSocketDelegate

extension RpcWebSocket: IWebSocketDelegate {
    func didUpdate(state: WebSocketState) {
        delegate?.didUpdate(socketState: state)
    }

    func didReceive(data: Data) {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data)

            if let rpcResponse = JsonRpcResponse.response(jsonObject: jsonObject) {
                delegate?.didReceive(rpcResponse: rpcResponse)
            } else if let subscriptionResponse = try? RpcSubscriptionResponse(JSONObject: jsonObject) {
                delegate?.didReceive(subscriptionResponse: subscriptionResponse)
            } else {
                throw ParseError.invalidResponse(jsonObject: jsonObject)
            }
        } catch {
            logger?.error("Handle Failed: \(error)")
        }
    }

    public func didReceive(text: String) {
        if let data = text.data(using: .utf8) {
            didReceive(data: data)
        }
    }
}

// MARK: RpcWebSocket.ParseError

extension RpcWebSocket {
    enum ParseError: Error {
        case invalidResponse(jsonObject: Any)
    }
}
