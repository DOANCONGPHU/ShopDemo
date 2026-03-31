//
//  CartManager.swift
//  ShopDemo
//
//  Created by gem on 30/3/26.
//

import Foundation

class CartManager{
    static let shared = CartManager()
    private init(){ }
    
    var cartItems: [Product] = []
    
    func addToCart(product : Product) {
        cartItems.append(product)
    }
    
    func totalPrice() -> Double {
        return cartItems.reduce(0) { $0 + $1.price }
    }
    
    
}
