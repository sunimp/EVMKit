//
//  JsonRpcResponse.swift
//
//  Created by Sun on 2020/9/22.
//

import Foundation

import ObjectMapper

// MARK: - JsonRpcResponse

public enum JsonRpcResponse {
    case success(SuccessResponse)
    case error(ErrorResponse)

    // MARK: Computed Properties

    var id: Int {
        switch self {
        case let .success(response):
            response.id
        case let .error(response):
            response.id
        }
    }

    // MARK: Static Functions

    static func response(jsonObject: Any) -> JsonRpcResponse? {
        if let successResponse = try? SuccessResponse(JSONObject: jsonObject) {
            return .success(successResponse)
        }

        if let errorResponse = try? ErrorResponse(JSONObject: jsonObject) {
            return .error(errorResponse)
        }

        return nil
    }
}

extension JsonRpcResponse {
    public struct SuccessResponse: ImmutableMappable {
        // MARK: Properties

        public let version: String
        public let id: Int
        public var result: Any?

        // MARK: Lifecycle

        public init(map: Map) throws {
            version = try map.value("jsonrpc")
            id = try map.value("id")

            guard map["result"].isKeyPresent else {
                throw MapError(key: "result", currentValue: nil, reason: nil)
            }

            result = try map.value("result")
        }
    }

    public struct ErrorResponse: ImmutableMappable {
        // MARK: Properties

        public let version: String
        public let id: Int
        public let error: RpcError

        // MARK: Lifecycle

        public init(map: Map) throws {
            version = try map.value("jsonrpc")
            id = try map.value("id")
            error = try map.value("error")
        }
    }

    public struct RpcError: ImmutableMappable {
        // MARK: Properties

        public let code: Int
        public let message: String
        public let data: Any?

        // MARK: Lifecycle

        public init(map: Map) throws {
            code = try map.value("code")
            message = try map.value("message")
            data = try? map.value("data")
        }
    }

    public enum ResponseError: Error {
        case rpcError(JsonRpcResponse.RpcError)
        case invalidResult(value: Any?)
    }
}
