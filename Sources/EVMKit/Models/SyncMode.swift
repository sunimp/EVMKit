//
//  SyncMode.swift
//  EVMKit
//
//  Created by Sun on 2019/11/26.
//

import Foundation

public enum SyncMode {
    case api
    case spv(nodePrivateKey: Data)
    case geth
}
