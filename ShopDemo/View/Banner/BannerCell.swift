//
//  BannerCell.swift
//  ShopDemo
//
//  Created by gem on 19/3/26.
//

import UIKit

class BannerCell: UITableViewCell {
    private var banners: [Product] = []
    
    @IBOutlet weak var collectionBanner: UICollectionView!
    @IBOutlet weak var pageCtrl: UIPageControl!

    override func awakeFromNib() {
        super.awakeFromNib()
        collectionBanner.delegate = self
        collectionBanner.dataSource = self
        collectionBanner.backgroundColor = .clear
    }

    func configure(with banners: [Product]) {
        guard !banners.isEmpty else { return }
        self.banners = banners
        pageCtrl.numberOfPages = banners.count
        collectionBanner.reloadData()
    }

}

extension BannerCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return banners.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionBanner.dequeueReusableCell(withReuseIdentifier: "BannerImageCell", for: indexPath) as? BannerCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: banners[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 160)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let width = scrollView.frame.width
            if width > 0 {
                let currentPage = Int((scrollView.contentOffset.x + width / 2) / width)
                pageCtrl.currentPage = currentPage
            }
        }


}
