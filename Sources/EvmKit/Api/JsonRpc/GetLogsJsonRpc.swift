//
//  GetLogsJsonRpc.swift
//
//  Created by Sun on 2020/8/28.
//

import Foundation

import WWExtensions

class GetLogsJsonRpc: JsonRpc<[TransactionLog]> {
    // MARK: Lifecycle

    init(address: Address?, fromBlock: DefaultBlockParameter?, toBlock: DefaultBlockParameter?, topics: [Any?]?) {
        var params = [String: Any]()

        if let address {
            params["address"] = address.hex
        }

        if let fromBlock {
            params["fromBlock"] = fromBlock.raw
        }

        if let toBlock {
            params["toBlock"] = toBlock.raw
        }

        if let topics {
            params["topics"] = topics.map { topic -> Any? in
                if let array = topic as? [Data?] {
                    return array.map { topic -> String? in
                        topic?.ww.hexString
                    }
                } else if let data = topic as? Data {
                    return data.ww.hexString
                } else {
                    return nil
                }
            }
        }

        super.init(
            method: "eth_getLogs",
            params: [params]
        )
    }

    // MARK: Overridden Functions

    override func parse(result: Any) throws -> [TransactionLog] {
        guard let array = result as? [Any] else {
            throw JsonRpcResponse.ResponseError.invalidResult(value: result)
        }

        return try array.map { jsonObject in
            try TransactionLog(JSONObject: jsonObject)
        }
    }
}
