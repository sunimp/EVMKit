import Foundation
import WWExtensions

class SendRawTransactionJsonRpc: DataJsonRpc {
    init(signedTransaction: Data) {
        super.init(
            method: "eth_sendRawTransaction",
            params: [signedTransaction.ww.hexString]
        )
    }
}
