//
//  ReviewManager.swift
//  ShopDemo
//
//  Created by gem on 3/4/26.
//

import Foundation
import UIKit

class ReviewManager {
    static let shared = ReviewManager()
    private init(){}
    
    func saveReviewLocal(review: ProductReview) {
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(review)
            
            let storageKey = "Review_\(review.productId)"
            
            UserDefaults.standard.set(encodedData, forKey: storageKey)
            
            print("Đã lưu review cho sp ID: \(review.productId)")
        } catch {
            print("Lỗi khi Encode dữ liệu : \(error.localizedDescription)")
        }
    }
    
    func getReviewLocal(productID: Int) -> ProductReview? {
        if let data = UserDefaults.standard.data(forKey: "Review_\(productID)") {
            
            do {
                let savedReview = try JSONDecoder().decode(ProductReview.self, from: data)
                print("Đã lấy được review. Số lượng ảnh Data: \(savedReview.imagesData.count)")
                return savedReview
            } catch {
                print("Lỗi: \(error)")
            }
        }
        return nil
    }
    

}
