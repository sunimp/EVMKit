//
//  RpcSubscription.swift
//  EVMKit
//
//  Created by Sun on 2020/8/28.
//

import Foundation

class RpcSubscription<T> {
    // MARK: Properties

    let params: [Any]

    // MARK: Lifecycle

    init(params: [Any]) {
        self.params = params
    }

    // MARK: Functions

    func parse(result _: Any) throws -> T {
        fatalError("This method should be overridden")
    }
}
