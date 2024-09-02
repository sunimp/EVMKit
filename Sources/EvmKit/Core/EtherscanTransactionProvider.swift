//
//  EtherscanTransactionProvider.swift
//
//  Created by Sun on 2022/2/18.
//

import Foundation

import Alamofire
import BigInt
import WWToolKit

// MARK: - EtherscanTransactionProvider

class EtherscanTransactionProvider {
    // MARK: Properties

    private let networkManager: NetworkManager
    private let baseURL: String
    private let apiKey: String
    private let address: Address

    // MARK: Lifecycle

    init(baseURL: String, apiKey: String, address: Address, logger: Logger) {
        networkManager = NetworkManager(interRequestInterval: 1, logger: logger)
        self.baseURL = baseURL
        self.apiKey = apiKey
        self.address = address
    }

    // MARK: Functions

    private func fetch(params: [String: Any]) async throws -> [[String: Any]] {
        let urlString = "\(baseURL)/api"

        var parameters = params
        parameters["apikey"] = apiKey

        let json = try await networkManager.fetchJson(
            url: urlString,
            method: .get,
            parameters: parameters,
            responseCacherBehavior: .doNotCache
        )

        guard let map = json as? [String: Any] else {
            throw RequestError.invalidResponse
        }

        guard let status = map["status"] as? String else {
            throw RequestError.invalidStatus
        }

        guard status == "1" else {
            let message = map["message"] as? String
            let result = map["result"] as? String

            // Etherscan API returns status 0 if no transactions found.
            // It is not error case, so we should not throw an error.
            if message == "No transactions found" {
                return []
            }

            if message == "NOTOK", let result, result.contains("Max rate limit reached") {
                throw RequestError.rateLimitExceeded
            }

            throw RequestError.responseError(message: message, result: result)
        }

        guard let result = map["result"] as? [[String: Any]] else {
            throw RequestError.invalidResult
        }

        return result
    }
}

// MARK: ITransactionProvider

extension EtherscanTransactionProvider: ITransactionProvider {
    func transactions(startBlock: Int) async throws -> [ProviderTransaction] {
        let params: [String: Any] = [
            "module": "account",
            "action": "txlist",
            "address": address.hex,
            "startblock": startBlock,
            "sort": "desc",
        ]

        let array = try await fetch(params: params)
        return array.compactMap { try? ProviderTransaction(JSON: $0) }
    }

    func internalTransactions(startBlock: Int) async throws -> [ProviderInternalTransaction] {
        let params: [String: Any] = [
            "module": "account",
            "action": "txlistinternal",
            "address": address.hex,
            "startblock": startBlock,
            "sort": "desc",
        ]

        let array = try await fetch(params: params)
        return array.compactMap { try? ProviderInternalTransaction(JSON: $0) }
    }

    func internalTransactions(transactionHash: Data) async throws -> [ProviderInternalTransaction] {
        let params: [String: Any] = [
            "module": "account",
            "action": "txlistinternal",
            "txhash": transactionHash.ww.hexString,
            "sort": "desc",
        ]

        let array = try await fetch(params: params)
        return array.compactMap { try? ProviderInternalTransaction(JSON: $0) }
    }

    func tokenTransactions(startBlock: Int) async throws -> [ProviderTokenTransaction] {
        let params: [String: Any] = [
            "module": "account",
            "action": "tokentx",
            "address": address.hex,
            "startblock": startBlock,
            "sort": "desc",
        ]

        let array = try await fetch(params: params)
        return array.compactMap { try? ProviderTokenTransaction(JSON: $0) }
    }

    public func eip721Transactions(startBlock: Int) async throws -> [ProviderEip721Transaction] {
        let params: [String: Any] = [
            "module": "account",
            "action": "tokennfttx",
            "address": address.hex,
            "startblock": startBlock,
            "sort": "desc",
        ]

        let array = try await fetch(params: params)
        return array.compactMap { try? ProviderEip721Transaction(JSON: $0) }
    }

    public func eip1155Transactions(startBlock: Int) async throws -> [ProviderEip1155Transaction] {
        let params: [String: Any] = [
            "module": "account",
            "action": "token1155tx",
            "address": address.hex,
            "startblock": startBlock,
            "sort": "desc",
        ]

        let array = try await fetch(params: params)
        return array.compactMap { try? ProviderEip1155Transaction(JSON: $0) }
    }
}

// MARK: EtherscanTransactionProvider.RequestError

extension EtherscanTransactionProvider {
    public enum RequestError: Error {
        case invalidResponse
        case invalidStatus
        case responseError(message: String?, result: String?)
        case invalidResult
        case rateLimitExceeded
    }
}
