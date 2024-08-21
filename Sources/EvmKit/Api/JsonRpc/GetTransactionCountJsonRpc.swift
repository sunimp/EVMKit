//
//  GetTransactionCountJsonRpc.swift
//  EvmKit
//
//  Created by Sun on 2024/8/21.
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
