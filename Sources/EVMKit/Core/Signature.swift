//
//  Signature.swift
//  EVMKit
//
//  Created by Sun on 2019/3/27.
//

import Foundation

import BigInt

public class Signature {
    // MARK: Properties

    let v: Int
    let r: BigUInt
    let s: BigUInt

    // MARK: Lifecycle

    init(v: Int, r: BigUInt, s: BigUInt) {
        self.v = v
        self.r = r
        self.s = s
    }
}
