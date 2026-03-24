//
//  BannerImageCell.swift
//  ShopDemo
//
//  Created by gem on 19/3/26.
//

import UIKit

class BannerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageBannerView: UIImageView!

    func configure(with banners: Product) {
        if let bannerUrl = URL(string: banners.thumbnail) {
            URLSession.shared.dataTask(with: bannerUrl){data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        self.imageBannerView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
    }
}
