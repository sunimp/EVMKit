//
//  DataJsonRpc.swift
//  EVMKit
//
//  Created by Sun on 2020/8/28.
//

import Foundation

class DataJsonRpc: JsonRpc<Data> {
    override func parse(result: Any) throws -> Data {
        guard let hexString = result as? String, let value = hexString.sw.hexData else {
            throw JsonRpcResponse.ResponseError.invalidResult(value: result)
        }

        return value
    }
}
