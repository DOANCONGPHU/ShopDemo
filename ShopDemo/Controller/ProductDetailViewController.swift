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
    
    var productID : Int?
    let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ShopDemo"
        setupViewModel()
        setupCollectionView()
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
    
    func configure() {
        guard let product = viewModel.productDetail else { return }
        
        nameLabel.text = product.title
        priceLabel.text = "$\(product.price)"
        ratingLabel.text = "⭐ \(product.rating)"
        describleTxt.text = product.description
        
        loadImage(from: product.thumbnail, into: imageViewProduct)
        
        collectionViewProduct.reloadData()
        
        guard !product.images.isEmpty else { return }
        collectionViewProduct.selectItem(
            at: IndexPath(item: 0, section: 0),
            animated: false,
            scrollPosition: .left
        )
    }

    private func loadImage(from urlString: String, into imageView: UIImageView) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            DispatchQueue.main.async {
                imageView.image = UIImage(data: data)
            }
        }.resume()
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
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.imageViewProduct.image =  UIImage(data: data)
            }
        }.resume()

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
