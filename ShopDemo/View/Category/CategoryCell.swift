//
//  CategoryCell.swift
//  ShopDemo
//
//  Created by gem on 20/3/26.
//

import UIKit

protocol CategoryDelegate : AnyObject{
    func didSelectCategory(_ category: Category)
}

class CategoryCell: UITableViewCell {
    @IBOutlet weak var collectionCategories: UICollectionView!
    private var category : [Category] = []
    weak var delegate : CategoryDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionCategories.delegate = self
        collectionCategories.dataSource = self
    }
    
    func config(with category : [Category] ) {
        self.category = category
        self.collectionCategories.reloadData()
        
    }

}
extension CategoryCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryLabelCell", for: indexPath) as? CategoryCollectionViewCell else{
            return UICollectionViewCell()
        }
        let category = category[indexPath.row]
        
        cell.configure(with: category)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return category.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selected = category[indexPath.item]
        delegate?.didSelectCategory(selected)
    }
}
