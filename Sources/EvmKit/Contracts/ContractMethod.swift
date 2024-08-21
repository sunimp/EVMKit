//
//  ContractMethod.swift
//  EvmKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

open class ContractMethod {
    
    public init() {}

    open var methodSignature: String {
        fatalError("Subclasses must override.")
    }

    open var arguments: [Any] {
        fatalError("Subclasses must override.")
    }

    public var methodId: Data {
        ContractMethodHelper.methodId(signature: methodSignature)
    }

    public func encodedABI() -> Data {
        ContractMethodHelper.encodedABI(methodId: methodId, arguments: arguments)
    }
}
