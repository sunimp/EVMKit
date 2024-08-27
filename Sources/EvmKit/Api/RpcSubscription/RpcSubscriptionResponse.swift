//
//  RpcSubscriptionResponse.swift
//  EvmKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import ObjectMapper

// MARK: - RpcSubscriptionResponse

struct RpcSubscriptionResponse: ImmutableMappable {
    let method: String
    let params: Params

    init(map: Map) throws {
        method = try map.value("method")
        params = try map.value("params")
    }
}

// MARK: RpcSubscriptionResponse.Params

extension RpcSubscriptionResponse {
    struct Params: ImmutableMappable {
        let subscriptionId: String
        let result: Any

        init(map: Map) throws {
            subscriptionId = try map.value("subscription", using: HexStringTransform())
            result = try map.value("result")
        }
    }
}
