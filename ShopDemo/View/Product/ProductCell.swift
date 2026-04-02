//
//  ProductCell.swift
//  ShopDemo
//
//  Created by gem on 20/3/26.
//

import UIKit

protocol ProductCellDelegate: AnyObject {
    func didAddToCart(on cell : ProductCell)
}
class ProductCell: UITableViewCell {
    
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addtoCartBtn: UIButton!
    @IBOutlet weak var productImageView: UIImageView!
    
    weak var delegate : ProductCellDelegate?
    
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
        ratingLabel.text = getRatingStars(rating: product.rating)
        productImageView.LoadImage(from: product.thumbnail)
    }
    
    func getRatingStars(rating: Double) -> String {
        let fullStars = Int(rating)
        let emptyStars = 5 - fullStars
        
        let stars = String(repeating: "⭐ ", count: fullStars) + String(repeating: " ", count: emptyStars)
        return "\(stars) \(rating)"
    }
    
    @IBAction func addToCartTapped(_ sender: UIButton) {
        print("them san pham vao gio")
        delegate?.didAddToCart(on: self)
    }
    
}
