//
//  ProductManager.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 26.10.2022.
//

import Foundation
import StoreKit


protocol ProductManagerDelegate {
    func productPurchased(_ product: Product)
    func productRestored(_ product: Product)
}

final class ProductManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    public static let shared = ProductManager()

    public var delegate: ProductManagerDelegate?

    public var products: [SKProduct]?

    override init() {
        super.init()
        
    }

    func fetchProducts() {
        let request = SKProductsRequest(productIdentifiers: Set(Product.allCases.compactMap({ $0.rawValue })))
        request.delegate = self
        request.start()
    }

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
    }

    public func purchase(product: Product) {
        guard SKPaymentQueue.canMakePayments() else {
            return
        }
        guard let storeKitProduct = products?.first(where: { $0.productIdentifier == product.rawValue }) else {
            return
        }

        let paymentRequest = SKPayment(product: storeKitProduct)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(paymentRequest)
    }

    public func restorePurchaes() {
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach {
            switch $0.transactionState {
                case .purchasing:
                    break
                case .purchased:
                    if let product = Product(rawValue: $0.payment.productIdentifier) {
                        delegate?.productPurchased(product)
                    }
                    SKPaymentQueue.default().finishTransaction($0)
                    SKPaymentQueue.default().remove(self)
                case .failed:
                    break
                case .restored:
                    if let product = Product(rawValue: $0.payment.productIdentifier) {
                        delegate?.productRestored(product)
                    }
                case .deferred:
                    break
                @unknown default:
                    break
            }
        }
    }
}
