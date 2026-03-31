//
//  CartCell.swift
//  ShopDemo
//
//  Created by gem on 30/3/26.
//

import UIKit

protocol CartCellDelegate: AnyObject {
    func removeProduct(productID : Int)
    func didChangeQuantity(productID: Int, quantity: Int)
}

class CartCell: UITableViewCell {

    @IBOutlet weak var priceProduct: UILabel!
    @IBOutlet weak var nameProduct: UILabel!
    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var removeProductBtn: UIButton!
    @IBOutlet weak var increaseBtn: UIButton!
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var decreaseBtn: UIButton!
    @IBOutlet weak var stackViewStepper: UIStackView!
    weak var delegate: CartCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    func setupUI() {
        removeProductBtn.layer.cornerRadius = 8
        selectionStyle = .none
        
        stackViewStepper.layer.borderWidth = 1
        stackViewStepper.layer.borderColor = UIColor.lightGray.cgColor
        stackViewStepper.layer.cornerRadius = 8
        
        imageProduct.layer.cornerRadius = 8
//        increaseBtn.layer.borderWidth = 1
//        decreaseBtn.layer.borderWidth = 1
//        quantityLbl.layer.borderWidth = 1
//        
//        quantityLbl.layer.borderColor = UIColor.lightGray.cgColor
//        increaseBtn.layer.borderColor = UIColor.lightGray.cgColor
//        decreaseBtn.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func configure(with item: Product){
        nameProduct.text = item.title
        priceProduct.text = "$\(item.price)"
        imageProduct.LoadImage(from: item.thumbnail)
        
    }
    

}
