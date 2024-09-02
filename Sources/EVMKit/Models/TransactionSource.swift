//
//  TransactionSource.swift
//
//  Created by Sun on 2022/2/21.
//

import Foundation

// MARK: - TransactionSource

public struct TransactionSource {
    // MARK: Nested Types

    public enum SourceType {
        case etherscan(apiBaseURL: String, txBaseURL: String, apiKey: String)
        case custom(apiURL: String, txURL: String)
    }

    // MARK: Properties

    public let name: String
    public let type: SourceType

    // MARK: Lifecycle

    public init(name: String, type: SourceType) {
        self.name = name
        self.type = type
    }

    // MARK: Functions

    public func transactionURL(hash: String) -> String {
        switch type {
        case let .etherscan(_, txBaseURL, _):
            "\(txBaseURL)/tx/\(hash)"
        case let .custom(_, txURL):
            "\(txURL)?hash=\(hash)"
        }
    }
}

extension TransactionSource {
    private static func etherscan(apiSubdomain: String, txSubdomain: String?, apiKey: String) -> TransactionSource {
        TransactionSource(
            name: "etherscan.io",
            type: .etherscan(
                apiBaseURL: "https://\(apiSubdomain).etherscan.io",
                txBaseURL: "https://\(txSubdomain.map { "\($0)." } ?? "")etherscan.io",
                apiKey: apiKey
            )
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
            type: .etherscan(apiBaseURL: "https://api.bscscan.com", txBaseURL: "https://bscscan.com", apiKey: apiKey)
        )
    }

    public static func bscscanTestNet(apiKey: String) -> TransactionSource {
        TransactionSource(
            name: "testnet.bscscan.com",
            type: .etherscan(
                apiBaseURL: "https://api-testnet.bscscan.com",
                txBaseURL: "https://testnet.bscscan.com",
                apiKey: apiKey
            )
        )
    }

    public static func polygonscan(apiKey: String) -> TransactionSource {
        TransactionSource(
            name: "polygonscan.com",
            type: .etherscan(
                apiBaseURL: "https://api.polygonscan.com",
                txBaseURL: "https://polygonscan.com",
                apiKey: apiKey
            )
        )
    }

    public static func snowtrace(apiKey: String) -> TransactionSource {
        TransactionSource(
            name: "snowtrace.io",
            type: .etherscan(apiBaseURL: "https://api.snowtrace.io", txBaseURL: "https://snowtrace.io", apiKey: apiKey)
        )
    }

    public static func optimisticEtherscan(apiKey: String) -> TransactionSource {
        TransactionSource(
            name: "optimistic.etherscan.io",
            type: .etherscan(
                apiBaseURL: "https://api-optimistic.etherscan.io",
                txBaseURL: "https://optimistic.etherscan.io",
                apiKey: apiKey
            )
        )
    }

    public static func arbiscan(apiKey: String) -> TransactionSource {
        TransactionSource(
            name: "arbiscan.io",
            type: .etherscan(apiBaseURL: "https://api.arbiscan.io", txBaseURL: "https://arbiscan.io", apiKey: apiKey)
        )
    }

    public static func gnosis(apiKey: String) -> TransactionSource {
        TransactionSource(
            name: "gnosisscan.io",
            type: .etherscan(
                apiBaseURL: "https://api.gnosisscan.io",
                txBaseURL: "https://gnosisscan.io",
                apiKey: apiKey
            )
        )
    }

    public static func fantom(apiKey: String) -> TransactionSource {
        TransactionSource(
            name: "ftmscan.com",
            type: .etherscan(apiBaseURL: "https://api.ftmscan.com", txBaseURL: "https://ftmscan.com", apiKey: apiKey)
        )
    }
}

extension TransactionSource {
    public static func custom(name: String, apiURL: String, txURL: String) -> TransactionSource {
        TransactionSource(
            name: name,
            type: .custom(apiURL: apiURL, txURL: txURL)
        )
    }
}
