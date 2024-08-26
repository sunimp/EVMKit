//
//  TransactionSource.swift
//  EvmKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

public struct TransactionSource {
    
    public enum SourceType {
        case etherscan(apiBaseUrl: String, txBaseUrl: String, apiKey: String)
        case custom(apiUrl: String, txUrl: String)
    }
    
    public let name: String
    public let type: SourceType

    public init(name: String, type: SourceType) {
        self.name = name
        self.type = type
    }

    public func transactionUrl(hash: String) -> String {
        switch type {
        case let .etherscan(_, txBaseUrl, _):
            return "\(txBaseUrl)/tx/\(hash)"
        case .custom(_, let txUrl):
            return "\(txUrl)/\(hash)"
        }
    }
}

extension TransactionSource {
    
    private static func etherscan(apiSubdomain: String, txSubdomain: String?, apiKey: String) -> TransactionSource {
        TransactionSource(
            name: "etherscan.io",
            type: .etherscan(apiBaseUrl: "https://\(apiSubdomain).etherscan.io", txBaseUrl: "https://\(txSubdomain.map { "\($0)." } ?? "")etherscan.io", apiKey: apiKey)
        )
    }

    public static func ethereumEtherscan(apiKey: String) -> TransactionSource {
        etherscan(apiSubdomain: "api", txSubdomain: nil, apiKey: apiKey)
    }

    public static func sepoliaEtherscan(apiKey: String) -> TransactionSource {
        etherscan(apiSubdomain: "api-sepolia", txSubdomain: "sepolia", apiKey: apiKey)
    }

    public static func ropstenEtherscan(apiKey: String) -> TransactionSource {
        etherscan(apiSubdomain: "api-ropsten", txSubdomain: "ropsten", apiKey: apiKey)
    }

    public static func kovanEtherscan(apiKey: String) -> TransactionSource {
        etherscan(apiSubdomain: "api-kovan", txSubdomain: "kovan", apiKey: apiKey)
    }

    public static func rinkebyEtherscan(apiKey: String) -> TransactionSource {
        etherscan(apiSubdomain: "api-rinkeby", txSubdomain: "rinkeby", apiKey: apiKey)
    }

    public static func goerliEtherscan(apiKey: String) -> TransactionSource {
        etherscan(apiSubdomain: "api-goerli", txSubdomain: "goerli", apiKey: apiKey)
    }

    public static func bscscan(apiKey: String) -> TransactionSource {
        TransactionSource(
            name: "bscscan.com",
            type: .etherscan(apiBaseUrl: "https://api.bscscan.com", txBaseUrl: "https://bscscan.com", apiKey: apiKey)
        )
    }

    public static func bscscanTestNet(apiKey: String) -> TransactionSource {
        TransactionSource(
            name: "testnet.bscscan.com",
            type: .etherscan(apiBaseUrl: "https://api-testnet.bscscan.com", txBaseUrl: "https://testnet.bscscan.com", apiKey: apiKey)
        )
    }

    public static func polygonscan(apiKey: String) -> TransactionSource {
        TransactionSource(
            name: "polygonscan.com",
            type: .etherscan(apiBaseUrl: "https://api.polygonscan.com", txBaseUrl: "https://polygonscan.com", apiKey: apiKey)
        )
    }

    public static func snowtrace(apiKey: String) -> TransactionSource {
        TransactionSource(
            name: "snowtrace.io",
            type: .etherscan(apiBaseUrl: "https://api.snowtrace.io", txBaseUrl: "https://snowtrace.io", apiKey: apiKey)
        )
    }

    public static func optimisticEtherscan(apiKey: String) -> TransactionSource {
        TransactionSource(
            name: "optimistic.etherscan.io",
            type: .etherscan(apiBaseUrl: "https://api-optimistic.etherscan.io", txBaseUrl: "https://optimistic.etherscan.io", apiKey: apiKey)
        )
    }

    public static func arbiscan(apiKey: String) -> TransactionSource {
        TransactionSource(
            name: "arbiscan.io",
            type: .etherscan(apiBaseUrl: "https://api.arbiscan.io", txBaseUrl: "https://arbiscan.io", apiKey: apiKey)
        )
    }

    public static func gnosis(apiKey: String) -> TransactionSource {
        TransactionSource(
            name: "gnosisscan.io",
            type: .etherscan(apiBaseUrl: "https://api.gnosisscan.io", txBaseUrl: "https://gnosisscan.io", apiKey: apiKey)
        )
    }

    public static func fantom(apiKey: String) -> TransactionSource {
        TransactionSource(
            name: "ftmscan.com",
            type: .etherscan(apiBaseUrl: "https://api.ftmscan.com", txBaseUrl: "https://ftmscan.com", apiKey: apiKey)
        )
    }
}

extension TransactionSource {
    
    public static func custom(name: String, apiUrl: String, txUrl: String) -> TransactionSource {
        TransactionSource(
            name: name,
            type: .custom(apiUrl: apiUrl, txUrl: txUrl)
        )
    }
}
