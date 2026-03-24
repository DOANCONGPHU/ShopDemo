//
//  HomeViewController.swift
//  ShopDemo
//
//  Created by gem on 19/3/26.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupTableView()
        setupViewModel()
    }
    
    private func setupNavigation() {
        title = "ShopDemo"
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.placeholder = "Search products"
        search.searchBar.delegate = self
        navigationItem.searchController = search
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            UINib(nibName: "ProductCell", bundle: nil),
            forCellReuseIdentifier: "ProductCell"
        )
    }
    
    private func setupViewModel() {
        viewModel.delegate = self
        viewModel.fetchAll()
    }
}

extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2 : viewModel.filteredProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return configureTopSection(at: indexPath)
        }
        return configureProductCell(at: indexPath)
    }
    
    private func configureTopSection(at indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BannerCell", for: indexPath) as! BannerCell
            cell.configure(with: viewModel.banners)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
            cell.config(with: viewModel.categories)
            cell.delegate = self
            return cell
        }
    }
    
    private func configureProductCell(at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCell
        cell.configure(with: viewModel.filteredProducts[indexPath.row])
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard indexPath.section == 1 else { return }
        
        let product = viewModel.filteredProducts[indexPath.row]
        navigateToDetail(with: product.id)
    }
    
    private func navigateToDetail(with productID: Int) {
        let storyboard = UIStoryboard(name: "ProductDetail", bundle: nil)
        guard let detailVC = storyboard.instantiateInitialViewController() as? ProductDetailViewController else { return }
        
        detailVC.productID = productID
        navigationController?.pushViewController(detailVC, animated: true)
    }
}


extension HomeViewController: CategoryDelegate {
    func didSelectCategory(_ category: Category) {
        viewModel.fetchCategoryDetail(category: category)
    }
}
extension HomeViewController: HomeViewModelDelegate {
    
    private func reloadTableSection(_ section: Int) {
        DispatchQueue.main.async {
            self.tableView.reloadSections(IndexSet(integer: section), with: .automatic)
        }
    }
    
    func didUpdateProducts() {
        reloadTableSection(1)
    }
    
    func didUpdateBanners() {
        reloadTableSection(0)
    }
    
    func didUpdateCategories() {
        reloadTableSection(0)
    }
    
    func didFailWithError(_ message: String) {
        print("Error: \(message)")
    }

    func didUpdateProductDetail() {}
    func didUpdateSearchResults() {}
}

extension HomeViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text,
              !keyword.isEmpty else { return }
        
        searchBar.resignFirstResponder()
        
        let searchVC = UIStoryboard(name: "SearchResult", bundle: nil)
            .instantiateInitialViewController() as! SearchResultViewController
        searchVC.keyword = keyword
        navigationController?.pushViewController(searchVC, animated: true)
    }
}
