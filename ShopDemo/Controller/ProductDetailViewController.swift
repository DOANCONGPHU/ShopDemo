//
//  ProductDetailViewController.swift
//  ShopDemo
//
//  Created by gem on 20/3/26.
//

import UIKit

class ProductDetailViewController: UIViewController {
    @IBOutlet weak var collectionViewProduct: UICollectionView!
    @IBOutlet weak var imageViewProduct: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var buyNowBtn: UIButton!
    @IBOutlet weak var addToCartBtn: UIButton!
    @IBOutlet weak var describleTxt: UITextView!
    @IBOutlet weak var reviewResultView: ReviewResultView!
    @IBOutlet weak var reviewContainerView: ReviewContainerView!
    
    var productID : Int?
    let viewModel = HomeViewModel()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    fileprivate func configReviewUI() {
        //Hiển thị kết quả khi đã review
        if PurchaseManager.shared.isReviewed(productID: productID!) {
            reviewResultView.isHidden = false
            reviewContainerView.isHidden = true
            if let savedData = ReviewManager.shared.getReviewLocal(productID: productID!) {
                self.reviewResultView.data = savedData
                    }
        }else {
            reviewResultView.isHidden = true
            //Cho đánh giá cho sản phẩm đã thanh toán
            if PurchaseManager.shared.isPurchased(productID: productID!) {
                reviewContainerView.isHidden = false
            } else {
                reviewContainerView.isHidden = true
            }
        }
    }
    
    func configure() {
        guard let product = viewModel.productDetail else { return }
        
        nameLabel.text = product.title
        priceLabel.text = "$\(product.price)"
        ratingLabel.text = "⭐ \(product.rating)"
        describleTxt.text = product.description
        imageViewProduct.LoadImage(from: product.thumbnail)
        
        collectionViewProduct.reloadData()
        
        guard !product.images.isEmpty else { return }
        collectionViewProduct.selectItem(
            at: IndexPath(item: 0, section: 0),
            animated: false,
            scrollPosition: .left
        )
        
        configReviewUI()
    }
}

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
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        self.present(picker, animated: true)
    }
    
    func openLibrary() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        self.present(picker, animated: true)
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
