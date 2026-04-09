//
//  AppCoordinator.swift
//  ShopDemo
//
//  Created by gem on 9/4/26.
//
import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    func start()
}

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showHome()
    }
    
    func showHome() {
        let vc = HomeViewController()
        vc.coordinator = self  
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showProductDetail(productID: Int) {
        let storyboard = UIStoryboard(name: "ProductDetail", bundle: nil)
        if let detailVC = storyboard.instantiateInitialViewController() as? ProductDetailViewController {
            detailVC.productID = productID
            navigationController.pushViewController(detailVC, animated: true)
        }
    }
    
    func showSearchResult(keyword: String){
        let storyboard = UIStoryboard(name: "SearchResult", bundle: nil)
        if let searchVC = storyboard.instantiateInitialViewController() as? SearchResultViewController {
            searchVC.keyword = keyword
            navigationController.pushViewController(searchVC, animated: true)
        }
    }
}
