//
//  EIP1559GasPriceProvider.swift
//
//  Created by Sun on 2022/2/9.
//

import Combine
import Foundation

import WWToolKit

// MARK: - EIP1559GasPriceProvider

public class EIP1559GasPriceProvider {
    // MARK: Nested Types

    public enum FeeHistoryError: Error {
        case notAvailable
    }

    // MARK: Static Properties

    private static let feeHistoryBlocksCount = 10
    private static let feeHistoryRewardPercentile = [50]

    // MARK: Properties

    private let evmKit: Kit

    // MARK: Lifecycle

    public init(evmKit: Kit) {
        self.evmKit = evmKit
    }

    // MARK: Functions

    public func gasPrice(defaultBlockParameter: DefaultBlockParameter = .latest) async throws -> GasPrice {
        let feeHistoryRequest = FeeHistoryJsonRpc(
            blocksCount: Self.feeHistoryBlocksCount,
            defaultBlockParameter: defaultBlockParameter,
            rewardPercentile: Self.feeHistoryRewardPercentile
        )
        let feeHistory = try await evmKit.fetch(rpcRequest: feeHistoryRequest)
        let tipsConsidered = feeHistory.reward.compactMap(\.first)
        let baseFeesConsidered = feeHistory.baseFeePerGas.suffix(2)

        guard !baseFeesConsidered.isEmpty, !tipsConsidered.isEmpty else {
            throw EIP1559GasPriceProvider.FeeHistoryError.notAvailable
        }

        let maxPriorityFeePerGas = tipsConsidered.reduce(0, +) / tipsConsidered.count
        let maxFeePerGas = (baseFeesConsidered.max() ?? 0) + maxPriorityFeePerGas
        return .eip1559(maxFeePerGas: maxFeePerGas, maxPriorityFeePerGas: maxPriorityFeePerGas)
    }
}

extension EIP1559GasPriceProvider {
    public static func gasPrice(
        networkManager: NetworkManager,
        rpcSource: RpcSource,
        defaultBlockParameter: DefaultBlockParameter = .latest
    ) async throws
        -> GasPrice {
        let feeHistoryRequest = FeeHistoryJsonRpc(
            blocksCount: Self.feeHistoryBlocksCount,
            defaultBlockParameter: defaultBlockParameter,
            rewardPercentile: Self.feeHistoryRewardPercentile
        )
        let feeHistory = try await RpcBlockchain.call(
            networkManager: networkManager,
            rpcSource: rpcSource,
            rpcRequest: feeHistoryRequest
        )
        let tipsConsidered = feeHistory.reward.compactMap(\.first)
        let baseFeesConsidered = feeHistory.baseFeePerGas.suffix(2)

        guard !baseFeesConsidered.isEmpty, !tipsConsidered.isEmpty else {
            throw EIP1559GasPriceProvider.FeeHistoryError.notAvailable
        }

        let maxPriorityFeePerGas = tipsConsidered.reduce(0, +) / tipsConsidered.count
        let maxFeePerGas = (baseFeesConsidered.max() ?? 0) + maxPriorityFeePerGas
        return .eip1559(maxFeePerGas: maxFeePerGas, maxPriorityFeePerGas: maxPriorityFeePerGas)
    }
}
