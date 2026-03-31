//
//  HomeViewModel.swift
//  ShopDemo
//
//  Created by gem on 20/3/26.
//

import Foundation

protocol HomeViewModelDelegate: AnyObject {
    func didUpdateProducts()
    func didUpdateBanners()
    func didUpdateProductDetail()
    func didFailWithError(_ message: String)
    func didUpdateCategories()
    func didUpdateSearchResults()
}

class HomeViewModel {
    weak var delegate: HomeViewModelDelegate?
    var filteredProducts: [Product] = []
    var banners: [Product] = []
    var categories: [Category] = []
    var productDetail: Product?
    var productSearch: [Product] = []
    
    func fetchAll() {
        fetchBanners()
        fetchCategories()
        fetchProducts()
    }
    func fetchBanners() {
        NetworkManager.shared.fetchBanners { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.banners = response.products
                delegate?.didUpdateBanners()
            case .failure(let error):
                delegate?.didFailWithError(self.errorMessage(error))
            }
        }
    }
    func fetchCategories() {
        NetworkManager.shared.fetchCategories { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let categories):
                let allCategory = Category(slug: "all", name: "All", url: "")
                self.categories = [allCategory] + categories
                delegate?.didUpdateCategories()
            case .failure(let error):
                delegate?.didFailWithError(self.errorMessage(error))
            }
        }
    }

    func fetchProducts() {
        NetworkManager.shared.fetchProducts { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.filteredProducts = response.products
                delegate?.didUpdateProducts()
            case .failure(let error):
                delegate?.didFailWithError(self.errorMessage(error))
            }
        }
    }

    func fetchCategoryDetail(category: Category) {
        if category.slug == "all" {
            fetchProducts()
            return
        }
        NetworkManager.shared.fetchCategoryDetail(category: category.slug) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.filteredProducts = response.products
                delegate?.didUpdateProducts( )
            case .failure(let error):
                delegate?.didFailWithError(self.errorMessage(error))
            }
        }
    }
    func fetchProductDetail(id : Int){
        NetworkManager.shared.fetchProductDetail(id: id) {
            [weak self] result in
            guard let self = self else { return }
            switch result {
            case.success(let response):
                self.productDetail = response
                delegate?.didUpdateProductDetail()
            case .failure(let error):
                delegate?.didFailWithError(self.errorMessage(error))
            }
        }
    }
    
    func fetchSearch(keyword : String){
        NetworkManager.shared.fetchSearch(keyword: keyword) {
            [weak self] result in
            guard let self = self else { return }
            switch result {
            case.success(let response):
                self.productSearch = response.products
                delegate?.didUpdateSearchResults()
            case .failure(let error):
                delegate?.didFailWithError(self.errorMessage(error))
            }
        }
    }
    
    private func errorMessage(_ error: NetworkError) -> String {
        switch error {
        case .invalidURL:            return "URL không hợp lệ"
        case .noData:                return "Không có dữ liệu"
        case .decodingError:         return "Lỗi đọc dữ liệu"
        case .serverError(let code): return "Lỗi server: \(code)"
        }
    }
}
