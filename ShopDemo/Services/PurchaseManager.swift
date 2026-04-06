//
//  PurchaseManager.swift
//  ShopDemo
//
//  Created by gem on 1/4/26.
//
import Foundation

class PurchaseManager {
    static let shared = PurchaseManager()
    private init(){}
    
    private let purchasedKey = "purchasedProductIDs"
    private let reviewKey = "reviewedProductIDs"
    
    //Purchase
    var purchasedIDs: [Int] {
        get { UserDefaults.standard.array(forKey: purchasedKey) as? [Int] ?? [] }
        set { UserDefaults.standard.set(newValue, forKey: purchasedKey) }
    }
    
    func addPurchased(productIDs: [Int]) {
        var currentIDs = purchasedIDs
        
        for id in productIDs {
            if !isPurchased(productID: id) {
                currentIDs.append(id)
                print("đã mua, review đi")
            }
        }
        purchasedIDs = currentIDs
    }

    func isPurchased(productID: Int) -> Bool {
        return purchasedIDs.contains(productID)
    }

    //Review
    var reviewedIDs: [Int] {
        get { UserDefaults.standard.array(forKey: reviewKey) as? [Int] ?? [] }
        set { UserDefaults.standard.set(newValue, forKey: reviewKey) }
    }
    
    func markAsReviewed(productID: Int) {
        if !isReviewed(productID: productID) {
            reviewedIDs.append(productID)
            UserDefaults.standard.set(reviewedIDs, forKey: reviewKey)
        }else {
            print("id: \(productID) đã được review rồi")
        }
    }
    
    func isReviewed(productID: Int) -> Bool {
        return reviewedIDs.contains(productID)
    }

}
