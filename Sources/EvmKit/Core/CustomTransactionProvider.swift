//
//  CustomTransactionProvider.swift
//  EvmKit
//
//  Created by Sun on 2024/8/26.
//

import Foundation

import Alamofire
import BigInt
import WWToolKit

// MARK: - CustomTransactionProvider

class CustomTransactionProvider {
    
    private let networkManager: NetworkManager
    private let baseUrl: String
    private let address: Address
    
    init(baseUrl: String, address: Address, logger: Logger) {
        networkManager = NetworkManager(interRequestInterval: 1, logger: logger)
        self.baseUrl = baseUrl
        self.address = address
    }
    
    private func fetch(path: String, params: [String: Any]) async throws -> [[String: Any]] {
        let urlString = "\(baseUrl)/\(path)"
        let json = try await networkManager.fetchJson(
            url: urlString,
            method: .get,
            parameters: params,
            responseCacherBehavior: .doNotCache
        )
        
        guard let result = json as? [[String: Any]] else {
            throw RequestError.invalidResponse
        }
        
        return result
    }
}

// MARK: ITransactionProvider

extension CustomTransactionProvider: ITransactionProvider {
    
    func transactions(startBlock _: Int) async throws -> [ProviderTransaction] {
        let params: [String: Any] = [
            "account": address.hex,
        ]
        
        let array = try await fetch(path: "getTransactionList", params: params)
        return array.compactMap { try? ProviderTransaction(JSON: $0) }
    }
    
    func internalTransactions(startBlock _: Int) async throws -> [ProviderInternalTransaction] {
        []
    }
    
    func internalTransactions(transactionHash _: Data) async throws -> [ProviderInternalTransaction] {
        []
    }
    
    func tokenTransactions(startBlock _: Int) async throws -> [ProviderTokenTransaction] {
        []
    }
    
    public func eip721Transactions(startBlock _: Int) async throws -> [ProviderEip721Transaction] {
        []
    }
    
    public func eip1155Transactions(startBlock _: Int) async throws -> [ProviderEip1155Transaction] {
        []
    }
}

// MARK: CustomTransactionProvider.RequestError

extension CustomTransactionProvider {
    
    public enum RequestError: Error {
        case invalidResponse
        case responseError(message: String?, result: String?)

    }
}
