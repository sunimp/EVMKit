//
//  LegacyGasPriceProvider.swift
//  EvmKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import WWToolKit

public class LegacyGasPriceProvider {
    private let evmKit: Kit

    public init(evmKit: Kit) {
        self.evmKit = evmKit
    }

    public func gasPrice() async throws -> GasPrice {
        let gasPrice = try await evmKit.fetch(rpcRequest: GasPriceJsonRpc())
        return .legacy(gasPrice: gasPrice)
    }
}

extension LegacyGasPriceProvider {
    
    public static func gasPrice(networkManager: NetworkManager, rpcSource: RpcSource) async throws -> GasPrice {
        let gasPrice = try await RpcBlockchain.call(networkManager: networkManager, rpcSource: rpcSource, rpcRequest: GasPriceJsonRpc())
        return .legacy(gasPrice: gasPrice)
    }
}
