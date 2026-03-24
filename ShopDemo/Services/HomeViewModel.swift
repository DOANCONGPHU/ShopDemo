//
//  HomeViewModel.swift
//  ShopDemo
//
//  Created by gem on 20/3/26.
//

import Foundation

class HomeViewModel {

    var filteredProducts: [Product] = []
    var banners: [Product] = []
    var products : [Product] = []
    var categories: [Category] = []
    var productDetail: Product?
    var productSearch: [Product] = []
    
    var onProductsUpdated: (() -> Void)?
    var onCategoriesUpdated: (() -> Void)?
    var onBannersUpdated: (() -> Void)?
    var onProductDetailUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    var onProductSearchUpdated: (() -> Void)?
    
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
                self.onBannersUpdated?()
            case .failure(let error):
                self.onError?(self.errorMessage(error))
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
                self.onCategoriesUpdated?()
            case .failure(let error):
                self.onError?(self.errorMessage(error))
            }
        }
    }

    func fetchProducts() {
        NetworkManager.shared.fetchProducts { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.filteredProducts = response.products
                self.onProductsUpdated?()
            case .failure(let error):
                self.onError?(self.errorMessage(error))
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
                self.onProductsUpdated?()
            case .failure(let error):
                self.onError?(self.errorMessage(error))
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
                self.onProductSearchUpdated?()
            case .failure(let error):
                self.onError?(self.errorMessage(error))
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
                self.onProductSearchUpdated?()
            case .failure(let error):
                self.onError?(self.errorMessage(error))
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
