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
    
    var cartItems: [CartItem] = []
    
    func addToCart(product : Product) {
        if let index = cartItems.firstIndex(where: { $0.product.id == product.id}) {
            cartItems[index].quantity += 1
            print("cap nhat them so luong khi add to cart")
            NotificationCenter.default.post(name: .cartUpdated, object: nil, userInfo: ["productID" : product.id, "action" : "update"])
        }else{
            cartItems.append(CartItem(product: product, quantity: 1))
            NotificationCenter.default.post(name: .cartUpdated,
                                            object: nil,
                                            userInfo: ["productID" : product.id, "action" : "add"])
        }
        
    }
    
    func totalPrice() -> Double {
        return cartItems.reduce(0) { $0 + $1.totalPrice }
    }
    
    func removeItem(at index: Int) {
        cartItems.remove(at: index)

    }

    func increaseQuantity(at index: Int) {
        cartItems[index].quantity += 1
    }
    
    func decreaseQuantity(at index: Int) {
        cartItems[index].quantity -= 1

    }
    
    func clearCart() {
        cartItems.removeAll()
    }

}
