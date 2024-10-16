//
//  IntJsonRpc.swift
//  EVMKit
//
//  Created by Sun on 2020/8/28.
//

import Foundation

import SWExtensions

class IntJsonRpc: JsonRpc<Int> {
    override func parse(result: Any) throws -> Int {
        guard let hexString = result as? String, let value = Int(hexString.sw.stripHexPrefix(), radix: 16) else {
            throw JsonRpcResponse.ResponseError.invalidResult(value: result)
        }

        return value
    }
}
