//
//  ContractMethodFactories.swift
//  EvmKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

open class ContractMethodFactories {
    public enum DecodeError: Error {
        case invalidABI
    }

    public init() { }

    private var factories = [Data: IContractMethodFactory]()

    public func register(factories: [IContractMethodFactory]) {
        for factory in factories {
            if let methodsFactory = factory as? IContractMethodsFactory {
                for methodID in methodsFactory.methodIDs {
                    self.factories[methodID] = factory
                }
            } else {
                self.factories[factory.methodID] = factory
            }
        }
    }

    public func createMethod(input: Data) -> ContractMethod? {
        let methodID = Data(input.prefix(4))
        let erc20MethodFactory = factories[methodID]

        return try? erc20MethodFactory?.createMethod(inputArguments: Data(input.suffix(from: 4)))
    }
}
