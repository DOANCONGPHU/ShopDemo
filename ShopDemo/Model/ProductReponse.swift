//
//  ProductReponse.swift
//  ShopDemo
//
//  Created by gem on 20/3/26.
//

import Foundation

struct ProductResponse: Codable {
    let products: [Product]
    let total: Int
}

struct Product: Codable {
    let id: Int
    let title: String
    let description: String
    let category: String
    let price: Double
    let discountPercentage: Double
    let rating: Double
    let tags: [String]
    let brand: String?
    let weight: Int
    let availabilityStatus: String
    let images: [String]
    let thumbnail: String
}
struct Category: Codable {
    let slug: String
    let name: String
    let url: String
}

