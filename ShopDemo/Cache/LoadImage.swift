//
//  LoadImage.swift
//  ShopDemo
//
//  Created by gem on 25/3/26.
//

import UIKit

extension UIImageView {
    func LoadImage(from urlString : String, placeholder: UIImage? = nil) {
        self.image = placeholder
        //ktra cache
        if let cached = ImageCache.shared.getImage(forkey: urlString as NSString) {
            self.image = cached
            return
        }
        // Tai anh tu mang
        guard let url = URL(string: urlString) else { return }
        let currentUrl = urlString
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data, let imageToCache = UIImage(data: data) else { return }
            ImageCache.shared.setImage(imageToCache, forkey: currentUrl as NSString)
            DispatchQueue.main.async {
                if self.accessibilityIdentifier == currentUrl {
                    self.image = imageToCache
                }
            }
        }.resume()
        self.accessibilityIdentifier = urlString
    }
}
