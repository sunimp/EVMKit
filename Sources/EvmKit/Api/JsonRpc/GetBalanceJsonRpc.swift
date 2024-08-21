//
//  GetBalanceJsonRpc.swift
//  EvmKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import BigInt

class GetBalanceJsonRpc: JsonRpc<BigUInt> {
    init(address: Address, defaultBlockParameter: DefaultBlockParameter) {
        super.init(
            method: "eth_getBalance",
            params: [address.hex, defaultBlockParameter.raw]
        )
    }

    override func parse(result: Any) throws -> BigUInt {
        guard let hexString = result as? String, let value = BigUInt(hexString.ww.stripHexPrefix(), radix: 16) else {
            throw JsonRpcResponse.ResponseError.invalidResult(value: result)
        }

        return value
    }
}
