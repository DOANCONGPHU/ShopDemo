//
//  ProductReview.swift
//  ShopDemo
//
//  Created by gem on 3/4/26.
//

import Foundation

struct ProductReview:Codable {
    let productId : Int
    let content : String
    let rate : Int
    let imagesData : [Data]
}
