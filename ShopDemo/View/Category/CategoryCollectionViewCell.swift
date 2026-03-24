//
//  CategoryCollectionViewCell.swift
//  ShopDemo
//
//  Created by gem on 20/3/26.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nameCategory: UILabel!
    
    override var isSelected: Bool {
        didSet {
            updateUI()
        }
    }
    func configure(with category: Category) {
        nameCategory.text = category.name
    }
    
    private func updateUI() {
        if isSelected {
            contentView.backgroundColor = .systemBlue
            nameCategory.textColor = .white
        } else {
            contentView.backgroundColor = .systemGray5
            nameCategory.textColor = .black
        }
    }
}
