//
//  ProductCell.swift
//  ShopDemo
//
//  Created by gem on 20/3/26.
//

import UIKit

class ProductCell: UITableViewCell {
    
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addtoCartBtn: UIButton!
    @IBOutlet weak var productImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        productImageView.layer.cornerRadius = 8
        productImageView.clipsToBounds = true
        addtoCartBtn.layer.cornerRadius = 8
    }
    
    func configure(with product: Product) {
        nameLabel.text = product.title
        priceLabel.text = "$\(product.price)"
        ratingLabel.text = "⭐ \(product.rating)"
        if let url = URL(string: product.thumbnail) {
            URLSession.shared.dataTask(with: url) { Data, _, _ in
                if let data = Data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.productImageView.image = image
                    }
                }
                
            }.resume()
        }
        
    }

}
