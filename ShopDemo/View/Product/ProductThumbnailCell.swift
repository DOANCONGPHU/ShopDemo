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
        guard let url = URL(string: imageUrl) else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        self.imageView.image = UIImage(data: data)
                    }
            }
        }.resume()
    }
    override var isSelected: Bool {
        didSet {
            layer.cornerRadius = 12
            layer.borderWidth = isSelected ? 2 : 0
            layer.borderColor = UIColor.systemBlue.cgColor
        }
    }
}
