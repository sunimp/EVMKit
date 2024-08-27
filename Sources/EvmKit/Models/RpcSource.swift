//
//  RpcSource.swift
//  EvmKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

// MARK: - RpcSource

public enum RpcSource {
    case http(urls: [URL], auth: String?)
    case webSocket(url: URL, auth: String?)
}

extension RpcSource {
    
    private static func infuraHttp(subdomain: String, projectID: String, projectSecret: String? = nil) -> RpcSource {
        .http(urls: [URL(string: "https://\(subdomain).infura.io/v3/\(projectID)")!], auth: projectSecret)
    }

    private static func infuraWebsocket(subdomain: String, projectID: String, projectSecret: String? = nil) -> RpcSource {
        .webSocket(url: URL(string: "wss://\(subdomain).infura.io/ws/v3/\(projectID)")!, auth: projectSecret)
    }

    public static func ethereumInfuraHttp(projectID: String, projectSecret: String? = nil) -> RpcSource {
        infuraHttp(subdomain: "mainnet", projectID: projectID, projectSecret: projectSecret)
    }

    public static func ethereumSepoliaHttp(projectID: String, projectSecret: String? = nil) -> RpcSource {
        infuraHttp(subdomain: "sepolia", projectID: projectID, projectSecret: projectSecret)
    }

    public static func ropstenInfuraHttp(projectID: String, projectSecret: String? = nil) -> RpcSource {
        infuraHttp(subdomain: "ropsten", projectID: projectID, projectSecret: projectSecret)
    }

    public static func kovanInfuraHttp(projectID: String, projectSecret: String? = nil) -> RpcSource {
        infuraHttp(subdomain: "kovan", projectID: projectID, projectSecret: projectSecret)
    }

    public static func rinkebyInfuraHttp(projectID: String, projectSecret: String? = nil) -> RpcSource {
        infuraHttp(subdomain: "rinkeby", projectID: projectID, projectSecret: projectSecret)
    }

    public static func goerliInfuraHttp(projectID: String, projectSecret: String? = nil) -> RpcSource {
        infuraHttp(subdomain: "goerli", projectID: projectID, projectSecret: projectSecret)
    }

    public static func ethereumInfuraWebsocket(projectID: String, projectSecret: String? = nil) -> RpcSource {
        infuraWebsocket(subdomain: "mainnet", projectID: projectID, projectSecret: projectSecret)
    }

    public static func ropstenInfuraWebsocket(projectID: String, projectSecret: String? = nil) -> RpcSource {
        infuraWebsocket(subdomain: "ropsten", projectID: projectID, projectSecret: projectSecret)
    }

    public static func kovanInfuraWebsocket(projectID: String, projectSecret: String? = nil) -> RpcSource {
        infuraWebsocket(subdomain: "kovan", projectID: projectID, projectSecret: projectSecret)
    }

    public static func rinkebyInfuraWebsocket(projectID: String, projectSecret: String? = nil) -> RpcSource {
        infuraWebsocket(subdomain: "rinkeby", projectID: projectID, projectSecret: projectSecret)
    }

    public static func goerliInfuraWebsocket(projectID: String, projectSecret: String? = nil) -> RpcSource {
        infuraWebsocket(subdomain: "goerli", projectID: projectID, projectSecret: projectSecret)
    }

    public static func bscRpcHttp() -> RpcSource {
        .http(urls: [URL(string: "https://bscrpc.com")!], auth: nil)
    }

    public static func binanceSmartChainHttp() -> RpcSource {
        .http(urls: [
            URL(string: "https://bsc-dataseed.binance.org")!,
            URL(string: "https://bsc-dataseed1.binance.org")!,
            URL(string: "https://bsc-dataseed2.binance.org")!,
            URL(string: "https://bsc-dataseed3.binance.org")!,
            URL(string: "https://bsc-dataseed4.binance.org")!,
        ], auth: nil)
    }

    public static func binanceSmartChainWebSocket() -> RpcSource {
        .webSocket(url: URL(string: "wss://bsc-ws-node.nariox.org:443")!, auth: nil)
    }

    public static func bscTestNet() -> RpcSource {
        .http(urls: [URL(string: "https://data-seed-prebsc-1-s1.binance.org:8545")!], auth: nil)
    }

    public static func polygonRpcHttp() -> RpcSource {
        .http(urls: [URL(string: "https://polygon-rpc.com")!], auth: nil)
    }

    public static func avaxNetworkHttp() -> RpcSource {
        .http(urls: [URL(string: "https://api.avax.network/ext/bc/C/rpc")!], auth: nil)
    }

    public static func optimismRpcHttp() -> RpcSource {
        .http(urls: [URL(string: "https://mainnet.optimism.io")!], auth: nil)
    }

    public static func arbitrumOneRpcHttp() -> RpcSource {
        .http(urls: [URL(string: "https://arb1.arbitrum.io/rpc")!], auth: nil)
    }

    public static func gnosisRpcHttp() -> RpcSource {
        .http(urls: [URL(string: "https://rpc.gnosischain.com")!], auth: nil)
    }

    public static func fantomRpcHttp() -> RpcSource {
        .http(urls: [URL(string: "https://rpc.fantom.network")!], auth: nil)
    }
}
