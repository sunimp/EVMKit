//
//  ContractMethodFactory.swift
//  EVMKit
//
//  Created by Sun on 2020/9/22.
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
