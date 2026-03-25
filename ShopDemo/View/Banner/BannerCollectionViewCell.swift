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
        imageBannerView.LoadImage(from: banners.thumbnail)
    }
}
