//
//  ReviewContainerView.swift
//  ShopDemo
//
//  Created by gem on 1/4/26.
//

import UIKit

protocol ReviewContainerDelegate: AnyObject {
    func didTapUpLoadImage()
    func didTapSendReview(content : String, rate : Int)
}

class ReviewContainerView: UIView {
    
    @IBOutlet weak var checkBox: UIButton!
    @IBOutlet weak var characterLbl: UILabel!
    @IBOutlet weak var reviewTxt: UITextView!
    @IBOutlet weak var reviewBtn: UIButton!
    @IBOutlet weak var upLoadCollection: UICollectionView!
    @IBOutlet var starButtons: [UIButton]!
    
    weak var delegate : ReviewContainerDelegate?
    var currentStar : Int = 0
    
    var selectedImages: [UIImage] = [] {
        didSet {
            upLoadCollection.reloadData()
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
    
    private func setupCollection() {
        let imageNib = UINib(nibName: "ImageUpLoadCell", bundle: nil)
        upLoadCollection.register(imageNib, forCellWithReuseIdentifier: "ImageUpLoadCell")
        
        let placeholderNib = UINib(nibName: "PlaceholderCell", bundle: nil)
        upLoadCollection.register(placeholderNib, forCellWithReuseIdentifier: "PlaceholderCell")
        
        upLoadCollection.delegate = self
        upLoadCollection.dataSource = self
    }
    
    private func loadFromXib() {
        print("loaded UI review")
        let xib = UINib(nibName: "ReviewContainer", bundle: nil)
        guard let view = xib.instantiate(withOwner: self, options: nil).first as? UIView else { return }

        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    @IBAction func starTapped(_ sender: UIButton) {
        let rating = sender.tag
            
        for button in starButtons {
            let isSelected = button.tag <= rating
            let imageName = isSelected ? "star.fill" : "star"
            button.setImage(UIImage(systemName: imageName), for: .normal)
            button.tintColor = isSelected ? .systemYellow : .systemGray4
        }
        self.currentStar = rating
    }
    
    @IBAction func reviewBtnTapped(_ sender: UIButton) {
        guard let content = reviewTxt.text else {return}
        delegate?.didTapSendReview(content: content, rate: self.currentStar)
        
        selectedImages = []
        reviewTxt.text = ""
        currentStar = 0
    }
    
}

extension ReviewContainerView: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selectedImages.isEmpty {
            return 1
        } else {
            return selectedImages.count + 1
        }
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if selectedImages.isEmpty {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceholderCell", for: indexPath) as! PlaceholderCell
            cell.delegate = self
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageUpLoadCell", for: indexPath) as! ImageUpLoadCell
            cell.indexPath = indexPath
            cell.delegate = self
            if indexPath.item == selectedImages.count{
                cell.configure(with: nil)
            }else {
                cell.configure(with: selectedImages[indexPath.item])
                
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if selectedImages.isEmpty {
            let width = collectionView.bounds.width
            return CGSize(width: width, height: 120)
        }
        return CGSize(width: 80, height: 80)
    }
}

extension ReviewContainerView: PlaceholderCellDelegate{
    func didTapAddImageFromPlaceholder() {
        self.delegate?.didTapUpLoadImage()
    }
}

extension ReviewContainerView : ImageUpLoadCellDelegate {
    func didTapAddImageFromUploadCell() {
        self.delegate?.didTapUpLoadImage()
    }
    
    func didTapDeleteImage(at index: IndexPath) {
        print("index : \(index) === item: \(index.item)")
        selectedImages.remove(at: index.item)
        upLoadCollection.reloadData()
//        upLoadCollection.deleteItems(at: [index])
    }
    
}

