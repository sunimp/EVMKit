//
//  NodeApiProvider.swift
//  EvmKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import Alamofire
import BigInt
import WWToolKit

// MARK: - NodeApiProvider

class NodeApiProvider {
    private let networkManager: NetworkManager
    private let urls: [URL]

    private let headers: HTTPHeaders
    private var currentRpcID = 0

    init(networkManager: NetworkManager, urls: [URL], auth: String?) {
        self.networkManager = networkManager
        self.urls = urls

        var headers = HTTPHeaders()

        if let auth {
            headers.add(.authorization(username: "", password: auth))
        }

        self.headers = headers
    }

    private func rpcResult(urlIndex: Int = 0, parameters: [String: Any]) async throws -> Any {
        do {
            return try await networkManager.fetchJson(
                url: urls[urlIndex],
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default,
                headers: headers,
                interceptor: self,
                responseCacherBehavior: .doNotCache
            )
        } catch {
            let nextIndex = urlIndex + 1

            if nextIndex < urls.count {
                return try await rpcResult(urlIndex: nextIndex, parameters: parameters)
            } else {
                throw error
            }
        }
    }
}

// MARK: RequestInterceptor

extension NodeApiProvider: RequestInterceptor {
    func retry(_: Request, for _: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        if case JsonRpcResponse.ResponseError.rpcError(let rpcError) = error, rpcError.code == -32005 {
            var backoffSeconds = 1.0

            if let errorData = rpcError.data as? [String: Any], let timeInterval = errorData["backoff_seconds"] as? TimeInterval {
                backoffSeconds = timeInterval
            }

            completion(.retryWithDelay(backoffSeconds))
        } else {
            completion(.doNotRetry)
        }
    }
}

// MARK: IRpcApiProvider

extension NodeApiProvider: IRpcApiProvider {
    var source: String {
        urls.compactMap(\.host).joined(separator: ", ")
    }

    func fetch<T>(rpc: JsonRpc<T>) async throws -> T {
        currentRpcID += 1

        let json = try await rpcResult(parameters: rpc.parameters(id: currentRpcID))

        guard let rpcResponse = JsonRpcResponse.response(jsonObject: json) else {
            throw RequestError.invalidResponse(jsonObject: json)
        }

        return try rpc.parse(response: rpcResponse)
    }
}

// MARK: NodeApiProvider.RequestError

extension NodeApiProvider {
    public enum RequestError: Error {
        case invalidResponse(jsonObject: Any)
    }
}
