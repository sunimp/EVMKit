//
//  CallJsonRpc.swift
//  EvmKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

class CallJsonRpc: DataJsonRpc {
    init(contractAddress: Address, data: Data, defaultBlockParameter: DefaultBlockParameter) {
        super.init(
            method: "eth_call",
            params: [
                ["to": contractAddress.hex, "data": data.ww.hexString],
                defaultBlockParameter.raw,
            ]
        )
    }
}
