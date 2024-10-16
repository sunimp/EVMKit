//
//  EIP1155Provider.swift
//  EVMKit
//
//  Created by Sun on 2022/5/5.
//

import Foundation

import BigInt
import SWToolKit

// MARK: - EIP1155Provider

public class EIP1155Provider {
    // MARK: Properties

    private let rpcApiProvider: IRpcApiProvider

    // MARK: Lifecycle

    init(rpcApiProvider: IRpcApiProvider) {
        self.rpcApiProvider = rpcApiProvider
    }
}

extension EIP1155Provider {
    public func balanceOf(contractAddress: Address, tokenID: BigUInt, address: Address) async throws -> BigUInt {
        let methodData = BalanceOfMethod(owner: address, tokenID: tokenID).encodedABI()
        let rpc = RpcBlockchain.callRpc(
            contractAddress: contractAddress,
            data: methodData,
            defaultBlockParameter: .latest
        )

        let data = try await rpcApiProvider.fetch(rpc: rpc)

        guard let value = BigUInt(data.prefix(32).sw.hex, radix: 16) else {
            throw BalanceError.invalidHex
        }

        return value
    }
}

// MARK: EIP1155Provider.BalanceOfMethod

extension EIP1155Provider {
    class BalanceOfMethod: ContractMethod {
        // MARK: Overridden Properties

        override var methodSignature: String {
            "balanceOf(address,uint256)"
        }

        override var arguments: [Any] {
            [owner, tokenID]
        }

        // MARK: Properties

        private let owner: Address
        private let tokenID: BigUInt

        // MARK: Lifecycle

        init(owner: Address, tokenID: BigUInt) {
            self.owner = owner
            self.tokenID = tokenID
        }
    }
}

extension EIP1155Provider {
    public enum BalanceError: Error {
        case invalidHex
    }

    public enum RpcSourceError: Error {
        case websocketNotSupported
    }
}

extension EIP1155Provider {
    public static func instance(rpcSource: RpcSource, minLogLevel: Logger.Level = .error) throws -> EIP1155Provider {
        let logger = Logger(minLogLevel: minLogLevel)
        let networkManager = NetworkManager(logger: logger)
        let rpcApiProvider: IRpcApiProvider

        switch rpcSource {
        case let .http(urls, auth):
            rpcApiProvider = NodeApiProvider(networkManager: networkManager, urls: urls, auth: auth)
        case .webSocket:
            throw RpcSourceError.websocketNotSupported
        }

        return EIP1155Provider(rpcApiProvider: rpcApiProvider)
    }
}
