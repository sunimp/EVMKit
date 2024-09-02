//
//  GetBalanceJsonRpc.swift
//
//  Created by Sun on 2020/8/28.
//

import Foundation

import BigInt

class GetBalanceJsonRpc: JsonRpc<BigUInt> {
    // MARK: Lifecycle

    init(address: Address, defaultBlockParameter: DefaultBlockParameter) {
        super.init(
            method: "eth_getBalance",
            params: [address.hex, defaultBlockParameter.raw]
        )
    }

    // MARK: Overridden Functions

    override func parse(result: Any) throws -> BigUInt {
        guard let hexString = result as? String, let value = BigUInt(hexString.ww.stripHexPrefix(), radix: 16) else {
            throw JsonRpcResponse.ResponseError.invalidResult(value: result)
        }

        return value
    }
}
