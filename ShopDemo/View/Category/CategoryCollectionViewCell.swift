//
//  CategoryCollectionViewCell.swift
//  ShopDemo
//
//  Created by gem on 20/3/26.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nameCategory: UILabel!
    
    func configure(with category: Category, isSelected: Bool) {
        nameCategory.text = category.name
        if isSelected {
            backgroundColor = .systemBlue
            nameCategory.textColor = .white
        } else {
            backgroundColor = .systemGray6
            nameCategory.textColor = .black
        }
    }
    
}
