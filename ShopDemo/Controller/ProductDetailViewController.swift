//
//  ProductDetailViewController.swift
//  ShopDemo
//
//  Created by gem on 20/3/26.
//

import UIKit

class ProductDetailViewController: UIViewController {
    @IBOutlet private weak var collectionViewProduct: UICollectionView!
    @IBOutlet private weak var imageViewProduct: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var buyNowBtn: UIButton!
    @IBOutlet private weak var addToCartBtn: UIButton!
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var reviewResultView: ReviewResultView!
    @IBOutlet private weak var reviewContainerView: ReviewContainerView!
    
    var productID : Int?
    private let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ShopDemo"
        setupViewModel()
        setupCollectionView()
        setupReviewContainer()
    }
    
    private func setupReviewContainer() {
        reviewContainerView.delegate = self
    }
    
    private func setupViewModel(){
        viewModel.delegate = self
        if let id = productID {
            viewModel.fetchProductDetail(id: id)
        }
        
    }
    
    private func setupCollectionView() {
        collectionViewProduct.dataSource = self
        collectionViewProduct.delegate = self
    }
    
    private func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = self
        present(picker, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    fileprivate func configReviewUI() {
        guard let id = productID else {
            reviewResultView.isHidden = true
            reviewContainerView.isHidden = true
            return
        }
        if PurchaseManager.shared.isReviewed(productID: id) {
            reviewResultView.isHidden = false
            reviewContainerView.isHidden = true
            if let savedData = ReviewManager.shared.getReviewLocal(productID: id) {
                reviewResultView.data = savedData
            }
        } else {
            reviewResultView.isHidden = true
            if PurchaseManager.shared.isPurchased(productID: id) {
                reviewContainerView.isHidden = false
            } else {
                reviewContainerView.isHidden = true
            }
        }
    }
    
    func configure() {
        guard let product = viewModel.productDetail else { return }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.nameLabel.text = product.title
            self.priceLabel.text = "$\(product.price)"
            self.ratingLabel.text = "⭐ \(product.rating)"
            self.descriptionTextView.text = product.description
            self.imageViewProduct.LoadImage(from: product.thumbnail)
            self.collectionViewProduct.reloadData()
            if !product.images.isEmpty {
                self.collectionViewProduct.selectItem(
                    at: IndexPath(item: 0, section: 0),
                    animated: false,
                    scrollPosition: .left
                )
            }
            self.configReviewUI()
        }
    }
}

// MARK: - UICollectionViewDataSource & Delegate
extension ProductDetailViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.productDetail?.images.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionViewProduct.dequeueReusableCell(withReuseIdentifier: "ThumbnailCell", for: indexPath) as? ProductThumbnailCell else {
            return UICollectionViewCell()
        }
        let url = viewModel.productDetail?.images[indexPath.item] ?? ""
        cell.configure(with: url)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let url = viewModel.productDetail?.images[indexPath.item] ?? ""
        imageViewProduct.LoadImage(from: url)
    }
}

// MARK: - HomeViewModelDelegate
extension ProductDetailViewController : HomeViewModelDelegate {
    func didUpdateProductDetail() {
        DispatchQueue.main.async {
            self.configure()
        }
    }
    
    func didFailWithError(_ message: String) {
        print("Error: \(message)")
    }
    
    func didUpdateCategories() {}
    func didUpdateSearchResults() {}
    func didUpdateProducts() {}
    func didUpdateBanners() {}
}

// MARK: - ReviewContainerDelegate
extension ProductDetailViewController: ReviewContainerDelegate{
    func didTapUpLoadImage() {
        
        let alert = UIAlertController(title: "Chọn ảnh", message: nil, preferredStyle: .actionSheet)
        
        // Camera
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            #if targetEnvironment(simulator)
            print("Đang chạy máy ảo - không hỗ trợ camera")
            #else
            self.openCamera()
            #endif
        }))
        
        // Thư viện
        alert.addAction(UIAlertAction(title: "Thư viện", style: .default, handler: { _ in
            self.openLibrary()
        }))
        
        // Huỷ
        alert.addAction(UIAlertAction(title: "Huỷ", style: .cancel))
        
        self.present(alert, animated: true)
    }
    
    func openCamera() {
        presentImagePicker(sourceType: .camera)
    }
    
    func openLibrary() {
        presentImagePicker(sourceType: .photoLibrary)
    }
    
    func didTapSendReview(content: String, rate: Int) {
        guard let currentID = self.productID else { return }
        
        PurchaseManager.shared.markAsReviewed(productID: currentID)
        
        let imagesAsData = self.reviewContainerView.selectedImages.compactMap { image in
            return image.jpegData(compressionQuality: 0.2)
        }
        
        let newReview = ProductReview(
            productId: currentID,
            content: content,
            rate: rate,
            imagesData: imagesAsData
        )
        
        UIView.animate(withDuration: 0.3) {
            ReviewManager.shared.saveReviewLocal(review: newReview)
            
            self.reviewResultView.data = newReview
            self.configReviewUI()
            
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - UIImagePickerControllerDelegate
extension ProductDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            print("Đã chọn ảnh: \(image)")
            self.reviewContainerView.selectedImages.append(image)
        }
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
