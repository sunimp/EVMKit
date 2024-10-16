//
//  LegacyGasPriceProvider.swift
//  EVMKit
//
//  Created by Sun on 2022/2/9.
//

import Foundation

import SWToolKit

// MARK: - LegacyGasPriceProvider

public class LegacyGasPriceProvider {
    // MARK: Properties

    private let evmKit: Kit

    // MARK: Lifecycle

    public init(evmKit: Kit) {
        self.evmKit = evmKit
    }

    // MARK: Functions

    public func gasPrice() async throws -> GasPrice {
        let gasPrice = try await evmKit.fetch(rpcRequest: GasPriceJsonRpc())
        return .legacy(gasPrice: gasPrice)
    }
}

extension LegacyGasPriceProvider {
    public static func gasPrice(networkManager: NetworkManager, rpcSource: RpcSource) async throws -> GasPrice {
        let gasPrice = try await RpcBlockchain.call(
            networkManager: networkManager,
            rpcSource: rpcSource,
            rpcRequest: GasPriceJsonRpc()
        )
        return .legacy(gasPrice: gasPrice)
    }
}
