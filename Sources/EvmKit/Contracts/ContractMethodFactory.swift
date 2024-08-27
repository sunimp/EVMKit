//
//  IContractMethodFactory.swift
//  EvmKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

// MARK: - IContractMethodFactory

public protocol IContractMethodFactory {
    var methodID: Data { get }
    func createMethod(inputArguments: Data) throws -> ContractMethod
}

// MARK: - IContractMethodsFactory

public protocol IContractMethodsFactory: IContractMethodFactory {
    var methodIDs: [Data] { get }
}

extension IContractMethodsFactory {
    var methodID: Data { Data() }
}
