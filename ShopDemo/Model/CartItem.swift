//
//  CartItem.swift
//  ShopDemo
//
//  Created by gem on 31/3/26.
//

import Foundation

struct CartItem:Codable{
    let product: Product
    var quantity: Int
    
    var totalPrice: Double {
        return product.price * Double(quantity)
    }
    
}
