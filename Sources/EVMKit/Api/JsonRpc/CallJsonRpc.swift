//
//  CallJsonRpc.swift
//
//  Created by Sun on 2020/8/28.
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
