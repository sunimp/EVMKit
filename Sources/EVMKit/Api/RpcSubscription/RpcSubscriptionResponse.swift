//
//  RpcSubscriptionResponse.swift
//  EVMKit
//
//  Created by Sun on 2020/9/22.
//

import Foundation

import ObjectMapper

// MARK: - RpcSubscriptionResponse

struct RpcSubscriptionResponse: ImmutableMappable {
    // MARK: Properties

    let method: String
    let params: Params

    // MARK: Lifecycle

    init(map: Map) throws {
        method = try map.value("method")
        params = try map.value("params")
    }
}

// MARK: RpcSubscriptionResponse.Params

extension RpcSubscriptionResponse {
    struct Params: ImmutableMappable {
        // MARK: Properties

        let subscriptionID: String
        let result: Any

        // MARK: Lifecycle

        init(map: Map) throws {
            subscriptionID = try map.value("subscription", using: HexStringTransform())
            result = try map.value("result")
        }
    }
}
