//
//  CartCell.swift
//  ShopDemo
//
//  Created by gem on 30/3/26.
//

import UIKit

protocol CartCellDelegate: AnyObject {
    func removeProduct(on cell : CartCell)
    func didChangeQuantity(on cell : CartCell, isIncrease : Bool)
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
 }
    
    func configure(with item: CartItem){
        nameProduct.text = item.product.title
        priceProduct.text = "$\(item.product.price)"
        imageProduct.LoadImage(from: item.product.thumbnail)
        
        updateQuantity(item.quantity)
    }
    
    @IBAction func didTapRemoveProduct(_ sender: UIButton) {
        delegate?.removeProduct(on: self)
    }
    
    @IBAction func didTapIncrease(_ sender: UIButton) {
        delegate?.didChangeQuantity(on : self, isIncrease: true)
    }
    
    @IBAction func didTapDecrease(_ sender: UIButton) {
        delegate?.didChangeQuantity(on : self, isIncrease: false)
    }
    
    func updateQuantity(_ quantity: Int) {
        quantityLbl.text = "\(quantity)"
        if quantity > 1 {
            decreaseBtn.isEnabled = true
        } else {
            decreaseBtn.isEnabled = false
        }
    }
}
