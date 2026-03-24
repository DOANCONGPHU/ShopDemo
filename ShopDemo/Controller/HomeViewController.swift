//
//  HomeViewController.swift
//  ShopDemo
//
//  Created by gem on 19/3/26.
//

import UIKit

class HomeViewController: UIViewController, CategoryDelegate{
    let viewModel = HomeViewModel()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Search
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.placeholder = "Search products"
        navigationItem.searchController = search
        // Call api
        viewModel.onBannersUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadSections(IndexSet(integer: 0), with: .none)
            }
        }
        viewModel.onCategoriesUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadSections(IndexSet(integer: 0), with: .none)
            }
        }
        // section 1
        viewModel.onProductsUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadSections(IndexSet(integer: 1), with: .none)
            }
        }
        viewModel.fetchAll()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    

}
extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    func didSelectCategory(_ category: Category) {
        viewModel.fetchCategoryDetail(category: category)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        return viewModel.filteredProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Banner + Categories
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "BannerCell", for: indexPath) as! BannerCell
                cell.configure(with: viewModel.banners)
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
                cell.config(with: viewModel.categories)
                cell.delegate = self
                return cell
            default:
                return UITableViewCell()
            }
        }
//        Products
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCell
        cell.configure(with: viewModel.filteredProducts[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 1 else { return }
        let product = viewModel.filteredProducts[indexPath.row]
        let detailVC = UIStoryboard(name: "ProductDetail", bundle: nil)
            .instantiateInitialViewController() as! ProductDetailViewController
        detailVC.productID = product.id
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

