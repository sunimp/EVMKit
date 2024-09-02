//
//  GetTransactionCountJsonRpc.swift
//
//  Created by Sun on 2020/8/28.
//

import Foundation

class GetTransactionCountJsonRpc: IntJsonRpc {
    init(address: Address, defaultBlockParameter: DefaultBlockParameter) {
        super.init(
            method: "eth_getTransactionCount",
            params: [address.hex, defaultBlockParameter.raw]
        )
    }
}
