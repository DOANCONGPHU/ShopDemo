//
//  ReviewImageCellCollectionViewCell.swift
//  ShopDemo
//
//  Created by gem on 3/4/26.
//

import UIKit

class ReviewImageCell: UICollectionViewCell {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var imageReview: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()

    }
        
    private func setupUI() {
        imageReview.layer.cornerRadius = 12
    }

    func configure(with image: UIImage) {
        self.imageReview.image = image
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageReview.image = nil
    }
}
extension ReviewResultView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
}
