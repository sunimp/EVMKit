//
//  FeeHistoryJsonRpc.swift
//  EvmKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import WWToolKit

// MARK: - ENSProvider

///  https://eips.ethereum.org/EIPS/eip-137#namehash-algorithm
public class ENSProvider {
    private static let registryAddress = try! Address(hex: "0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e")
    private let rpcApiProvider: IRpcApiProvider

    init(rpcApiProvider: IRpcApiProvider) {
        self.rpcApiProvider = rpcApiProvider
    }

    private func resolve(name: String, level: Level) async throws -> Address {
        let nameHash = NameHash.nameHash(name: name)
        let methodData = ResolverMethod(hash: nameHash, method: level.name).encodedABI()
        let rpc = RpcBlockchain.callRpc(contractAddress: level.address, data: methodData, defaultBlockParameter: .latest)

        let data = try await rpcApiProvider.fetch(rpc: rpc)
        let address = data.prefix(32).suffix(20).ww.hexString
        return try Address(hex: address)
    }
}

extension ENSProvider {
    
    public func resolveAddress(domain: String) async throws -> Address {
        guard let resolverAddress = try? await resolve(name: domain, level: .resolver) else {
            throw ResolveError.noAnyResolver
        }

        guard let address = try? await resolve(name: domain, level: .addr(resolver: resolverAddress)) else {
            throw ResolveError.noAnyAddress
        }

        return address
    }
}

// MARK: ENSProvider.ResolverMethod

extension ENSProvider {
    class ResolverMethod: ContractMethod {
        private let hash: Data32
        private let method: String

        init(hash: Data32, method: String) {
            self.hash = hash
            self.method = method
        }

        override var methodSignature: String {
            "\(method)(bytes32)"
        }

        override var arguments: [Any] {
            [hash]
        }
    }
}

// MARK: ENSProvider.Level

extension ENSProvider {
    enum Level {
        case resolver
        case addr(resolver: Address)

        var name: String {
            switch self {
            case .resolver: "resolver"
            case .addr: "addr"
            }
        }

        var address: Address {
            switch self {
            case .resolver: ENSProvider.registryAddress
            case .addr(let address): address
            }
        }
    }
}

extension ENSProvider {
    
    public enum ResolveError: Error {
        case noAnyResolver
        case noAnyAddress
    }

    public enum RpcSourceError: Error {
        case websocketNotSupported
    }
}

extension ENSProvider {
    
    public static func instance(rpcSource: RpcSource, minLogLevel: Logger.Level = .error) throws -> ENSProvider {
        let logger = Logger(minLogLevel: minLogLevel)
        let networkManager = NetworkManager(logger: logger)
        let rpcApiProvider: IRpcApiProvider

        switch rpcSource {
        case .http(let urls, let auth):
            rpcApiProvider = NodeApiProvider(networkManager: networkManager, urls: urls, auth: auth)
        case .webSocket:
            throw RpcSourceError.websocketNotSupported
        }

        return ENSProvider(rpcApiProvider: rpcApiProvider)
    }
}
