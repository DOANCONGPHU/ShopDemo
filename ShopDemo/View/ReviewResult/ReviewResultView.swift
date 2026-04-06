//
//  ReviewResultView.swift
//  ShopDemo
//
//  Created by gem on 3/4/26.
//

import UIKit

class ReviewResultView: UIView{
    
    @IBOutlet weak var reviewResultTxt: UITextView!
    @IBOutlet weak var imageReviewCollection: UICollectionView!
    @IBOutlet var starReviews: [UIImageView]!
    
    private var listImages: [UIImage] = []
    var data: ProductReview? {
        didSet {
            guard let data = data else { return }
            
            reviewResultTxt.text = data.content
            
            for (index, star) in starReviews.enumerated() {
                star.tintColor = index < data.rate ? .systemYellow : .systemGray4
            }
            
            self.listImages = data.imagesData.compactMap { UIImage(data: $0) }
            print("\(self.listImages.count) UIImage để hiển thị")
            DispatchQueue.main.async {
                self.imageReviewCollection.reloadData()
                print("Reload CollectionView")
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromXib()
        setupCollection()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadFromXib()
        setupCollection()
    }
    
    fileprivate func setupCollection() {
        imageReviewCollection.delegate = self
        imageReviewCollection.dataSource = self
        
        let reviewImageNib = UINib(nibName: "ReviewImageCell", bundle: nil)
        imageReviewCollection.register(reviewImageNib, forCellWithReuseIdentifier: "ReviewImageCell")
    }
    
    private func loadFromXib() {
        let xib = UINib(nibName: "ReviewResult", bundle: nil)
        guard let view = xib.instantiate(withOwner: self, options: nil).first as? UIView
        else { return }
        
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
}

extension ReviewResultView : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageReviewCollection.dequeueReusableCell(withReuseIdentifier: "ReviewImageCell", for: indexPath) as! ReviewImageCell
        cell.configure(with: listImages[indexPath.item])
        return cell
    }
    
    
}
