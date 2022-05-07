import SwiftyStoreKit
import StoreKit
import Defaults

struct PurchaseHelper {
    static func verifyPurchase() {
        fetchReceipt() { receipt in
            let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: "your-shared-secret")
            SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
                switch result {
                case .success(let receipt):
                    let productId = "com.musevisions.SwiftyStoreKit.Purchase1"
                    // Verify the purchase of Consumable or NonConsumable
                    let purchaseResult = SwiftyStoreKit.verifyPurchase(
                        productId: productId,
                        inReceipt: receipt)
                    
                    switch purchaseResult {
                    case .purchased(let receiptItem):
                        Defaults[.isPurchased] = true
                        print("\(productId) is purchased: \(receiptItem)")
                    case .notPurchased:
                        Defaults[.isPurchased] = false
                        print("The user has never purchased \(productId)")
                    }
                case .error(let error):
                    print("Receipt verification failed: \(error)")
                }
            }
        }
    }
    
    static func fetchReceipt(callback: @escaping (_ receipt: String?) -> Void) {
        let receiptData = SwiftyStoreKit.localReceiptData
        let receiptString = receiptData?.base64EncodedString(options: [])
        
        if receiptString != nil {
            callback(receiptString)
            return
        }
        
        SwiftyStoreKit.fetchReceipt(forceRefresh: true) { result in
            switch result {
            case .success(let receiptData):
                let encryptedReceipt = receiptData.base64EncodedString(options: [])
                callback(encryptedReceipt)
            case .error(let error):
                print("Fetch receipt failed: \(error)")
            }
        }
    }
}

