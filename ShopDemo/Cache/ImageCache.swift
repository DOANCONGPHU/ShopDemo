//
//  ImageCache.swift
//  ShopDemo
//
//  Created by gem on 25/3/26.
//

import Foundation
import UIKit

class ImageCache {
    static let shared = ImageCache()
    private init() {
        cache.countLimit = 100
        cache.totalCostLimit = 50*1024*1024
    }
    
    private var cache = NSCache<NSString, UIImage>()
    
    func setImage(_ image: UIImage, forkey key : NSString) {
        cache.setObject(image, forKey: key)
    }
    func getImage(forkey key : NSString) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
}
