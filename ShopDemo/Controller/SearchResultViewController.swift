//
//  SearchResultViewController.swift
//  ShopDemo
//
//  Created by gem on 24/3/26.
//

import UIKit

class SearchResultViewController: UIViewController{

    @IBOutlet weak var tableView: UITableView!
    var keyword: String = ""
    let viewModel = HomeViewModel()
    weak var coordinator: AppCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search Result"
        viewModel.delegate = self
        viewModel.fetchSearch(keyword: keyword)
        print("\(keyword)")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            UINib(nibName: "ProductCell", bundle: nil),
            forCellReuseIdentifier: "ProductCell"
        )
    }

}

extension SearchResultViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return viewModel.productSearch.count  
    }

    func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCell
        cell.configure(with: viewModel.productSearch[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        coordinator?.showProductDetail(productID: viewModel.productSearch[indexPath.row].id)
    }
}

extension SearchResultViewController : HomeViewModelDelegate{
    func didUpdateSearchResults() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didUpdateProducts() {}
    func didUpdateBanners() {}
    func didUpdateProductDetail() {}
    func didUpdateCategories() {}
    
    func didFailWithError(_ message: String) {
        print("Error: \(message)")
    }
    
}
