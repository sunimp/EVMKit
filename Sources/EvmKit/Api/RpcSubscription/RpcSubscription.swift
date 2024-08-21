//
//  RpcSubscription.swift
//  EvmKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

class RpcSubscription<T> {
    let params: [Any]

    init(params: [Any]) {
        self.params = params
    }

    func parse(result _: Any) throws -> T {
        fatalError("This method should be overridden")
    }
}
