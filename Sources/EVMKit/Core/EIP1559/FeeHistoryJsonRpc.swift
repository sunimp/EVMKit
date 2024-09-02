//
//  FeeHistoryJsonRpc.swift
//
//  Created by Sun on 2022/2/9.
//

import Foundation

import BigInt

class FeeHistoryJsonRpc: JsonRpc<FeeHistory> {
    // MARK: Lifecycle

    init(blocksCount: Int, defaultBlockParameter: DefaultBlockParameter, rewardPercentile: [Int]) {
        let params: [Any] = [
            "0x" + String(blocksCount, radix: 16).ww.removeLeadingZeros(),
            defaultBlockParameter.raw,
            rewardPercentile,
        ]

        super.init(
            method: "eth_feeHistory",
            params: params
        )
    }

    // MARK: Overridden Functions

    override func parse(result: Any) throws -> FeeHistory {
        try FeeHistory(JSONObject: result)
    }
}
