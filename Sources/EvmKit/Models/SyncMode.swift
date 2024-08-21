//
//  SyncMode.swift
//  EvmKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

public enum SyncMode {
    case api
    case spv(nodePrivateKey: Data)
    case geth
}
