//
//  TransactionTagQuery.swift
//  EVMKit
//
//  Created by Sun on 2022/9/28.
//

import Foundation

public class TransactionTagQuery {
    // MARK: Properties

    public let type: TransactionTag.TagType?
    public let `protocol`: TransactionTag.TagProtocol?
    public let contractAddress: Address?
    public let address: String?

    // MARK: Computed Properties

    var isEmpty: Bool {
        type == nil && `protocol` == nil && contractAddress == nil && address == nil
    }

    // MARK: Lifecycle

    public init(
        type: TransactionTag.TagType? = nil,
        protocol: TransactionTag.TagProtocol? = nil,
        contractAddress: Address? = nil,
        address: String? = nil
    ) {
        self.type = type
        self.protocol = `protocol`
        self.contractAddress = contractAddress
        self.address = address
    }
}
