//
//  IAPHandler.swift
//  DodgeIt
//
//  Created by Jonathan Oh on 11/15/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

// TODO: Always check at start of app if user is the actual purchaser (user logs in with apple id with purchase, restores then goes in to old accout to keep userdefaults)

import UIKit
import StoreKit

enum IAPHandlerAlertType{
    case disabled
    case restored
    case purchased
    case failed
    
    func message() -> String{
        switch self {
        case .disabled: return "Purchases are disabled in your device!"
        case .restored: return "You've successfully restored your purchase!"
        case .purchased: return "You've successfully bought this purchase!"
        case .failed: return "Purchase failed!"
        }
    }
}


class IAPHandler: NSObject {
    static let shared = IAPHandler()
    
    let CONSUMABLE_PURCHASE_PRODUCT_ID = "testpurchase"
    let NON_CONSUMABLE_PURCHASE_PRODUCT_ID = "non.consumable"
    
    fileprivate var productID = ""
    fileprivate var productsRequest = SKProductsRequest()
    //fileprivate var iapProducts = [SKProduct]()
    fileprivate var iapProductDictionary = [String:SKProduct]()
    
    var purchaseStatusBlock: ((IAPHandlerAlertType) -> Void)?
    
    // MARK: - MAKE PURCHASE OF A PRODUCT
    func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }
    
    func purchaseMyProduct(productIdentifier: String){
        //if iapProducts.count == 0 { return }
        guard let productExists = iapProductDictionary[productIdentifier] else { return }
        if self.canMakePurchases() {
            //let product = iapProducts[index]
            let payment = SKPayment(product: productExists)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
            
            print("PRODUCT TO PURCHASE: \(productExists.productIdentifier)")
            self.productID = productExists.productIdentifier
        } else {
            purchaseStatusBlock?(.disabled)
        }
    }
    
    // MARK: - RESTORE PURCHASE
    func restorePurchase(){
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    
    // MARK: - FETCH AVAILABLE IAP PRODUCTS
    func fetchAvailableProducts(){
        
        // Put here your IAP Products ID's
        let productIdentifiers = NSSet(objects: "adRemovalPurchase", "GrimReaper3", "Nubis1", "Pat2","RedEyeNinja3","BowlHairNinja3","HammaTime6","Samurai7","Brainsss8")//NSSet(objects: CONSUMABLE_PURCHASE_PRODUCT_ID,NON_CONSUMABLE_PURCHASE_PRODUCT_ID)
        
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
        productsRequest.delegate = self
        productsRequest.start()
    }
}

extension IAPHandler: SKProductsRequestDelegate, SKPaymentTransactionObserver {
    // MARK: - REQUEST IAP PRODUCTS
    func productsRequest (_ request:SKProductsRequest, didReceive response:SKProductsResponse) {
        
        if (response.products.count > 0) {
//            iapProducts = response.products
//            for product in iapProducts{
//                let numberFormatter = NumberFormatter()
//                numberFormatter.formatterBehavior = .behavior10_4
//                numberFormatter.numberStyle = .currency
//                numberFormatter.locale = product.priceLocale
//                let price1Str = numberFormatter.string(from: product.price)
//                print(product.localizedDescription + "\nfor just \(price1Str!)")
//            }
            let iapProducts = response.products
            for product in iapProducts {
                iapProductDictionary[product.productIdentifier] = product
                let numberFormatter = NumberFormatter()
                numberFormatter.formatterBehavior = .behavior10_4
                numberFormatter.numberStyle = .currency
                numberFormatter.locale = product.priceLocale
                let price1Str = numberFormatter.string(from: product.price)
                print(product.localizedDescription + "\nfor just \(price1Str!)")
            }
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        purchaseStatusBlock?(.restored)
    }
    
    // MARK:- IAP PAYMENT QUEUE
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans = transaction as? SKPaymentTransaction {
                print(trans.transactionIdentifier ?? "")
                switch trans.transactionState {
                case .purchased:
                    print("purchased")
                    setUsersPurchaseDefaults()
                    purchaseStatusBlock?(.purchased)
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                case .failed:
                    print("failed")
                    purchaseStatusBlock?(.failed)
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                case .restored:
                    print("restored")
                    setUsersPurchaseDefaults()
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    purchaseStatusBlock?(.restored)
                case .purchasing:
                    print("purchasing")
                case .deferred:
                    print("deferred")
                }
            }
        }
    }
    
    func setUsersPurchaseDefaults() {
        UserDefaults.standard.set(true, forKey: "adRemovalPurchase")
    }
    
}

