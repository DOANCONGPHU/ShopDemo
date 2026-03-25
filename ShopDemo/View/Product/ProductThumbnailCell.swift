//
//  ProductThumbnailCell.swift
//  ShopDemo
//
//  Created by gem on 24/3/26.
//

import UIKit

class ProductThumbnailCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    func configure(with imageUrl: String) {
        imageView.LoadImage(from: imageUrl)
    }
    override var isSelected: Bool {
        didSet {
            layer.cornerRadius = 12
            layer.borderWidth = isSelected ? 2 : 0
            layer.borderColor = UIColor.systemBlue.cgColor
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = UIImage(named: "placeholder_icon")
        self.layer.borderColor = UIColor.clear.cgColor
    }
}
