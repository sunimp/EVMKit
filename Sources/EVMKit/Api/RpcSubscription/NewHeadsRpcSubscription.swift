//
//  NewHeadsRpcSubscription.swift
//  EVMKit
//
//  Created by Sun on 2020/8/28.
//

import Foundation

import SWExtensions

// MARK: - NewHeadsRpcSubscription

class NewHeadsRpcSubscription: RpcSubscription<RpcBlockHeader> {
    // MARK: Lifecycle

    init() {
        super.init(params: ["newHeads"])
    }

    // MARK: Overridden Functions

    override func parse(result: Any) throws -> RpcBlockHeader {
        guard let resultMap = result as? [String: Any] else {
            throw ParseError.invalidResult(result: result)
        }

        guard
            let numberHex = resultMap["number"] as? String,
            let number = Int(numberHex.sw.stripHexPrefix(), radix: 16)
        else {
            throw ParseError.noBlockNumber(resultMap: resultMap)
        }

        guard let logsBloom = resultMap["logsBloom"] as? String else {
            throw ParseError.noLogsBloom(resultMap: resultMap)
        }

        return RpcBlockHeader(number: number, logsBloom: logsBloom)
    }
}

// MARK: NewHeadsRpcSubscription.ParseError

extension NewHeadsRpcSubscription {
    enum ParseError: Error {
        case invalidResult(result: Any)
        case noBlockNumber(resultMap: [String: Any])
        case noLogsBloom(resultMap: [String: Any])
    }
}

// MARK: - RpcBlockHeader

struct RpcBlockHeader {
    let number: Int
    let logsBloom: String
}
