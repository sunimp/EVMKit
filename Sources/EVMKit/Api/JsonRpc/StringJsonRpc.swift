//
//  StringJsonRpc.swift
//
//  Created by Sun on 2021/2/15.
//

import Foundation

class StringJsonRpc: JsonRpc<String> {
    override func parse(result: Any) throws -> String {
        guard let string = result as? String else {
            throw JsonRpcResponse.ResponseError.invalidResult(value: result)
        }

        return string
    }
}
