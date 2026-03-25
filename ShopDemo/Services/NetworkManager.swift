//
//  NetworkManager.swift
//  ShopDemo
//
//  Created by gem on 20/3/26.
//

import Alamofire

enum NetworkError: Error {
    case noData
    case decodingError
    case serverError(Int)
    case invalidURL
}

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    private let baseURL = "https://dummyjson.com"
    
    func fetch<T : Codable>(
    endpoint: String,
    completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        guard let url = URL(string: baseURL + endpoint) else {
            completion(.failure(.invalidURL))
            return
        }
        // call api
        AF.request(url)
            .validate() //tự bắt các lỗi server
            .responseDecodable(of: T.self) // tự decode JSON
        { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                if let statusCode = response.response?.statusCode {
                    completion(.failure(.serverError(statusCode)))
                } else if error.isSessionTaskError {
                    completion(.failure(.noData))
                }
                else {
                    completion(.failure(.decodingError))
                }
            }
        }
    }
    
    func fetchProducts(completion: @escaping (Result<ProductResponse, NetworkError>) -> Void) {
        fetch(endpoint: "/products", completion: completion)
    }
    func fetchCategoryDetail(category: String, completion: @escaping (Result<ProductResponse, NetworkError>) -> Void) {
        fetch(endpoint: "/products/category/\(category)", completion: completion)
    }
    func fetchCategories(completion: @escaping (Result<[Category], NetworkError>) -> Void) {
        fetch(endpoint: "/products/categories", completion: completion)
    }
    func fetchProductDetail(id: Int, completion: @escaping (Result<Product, NetworkError>) -> Void) {
        fetch(endpoint:"/products/\(id)",completion: completion)
    }
    func fetchSearch(keyword: String, completion: @escaping (Result<ProductResponse, NetworkError>) -> Void){
        fetch(endpoint: "/products/search?q=\(keyword)", completion: completion)
    }
    func fetchBanners(completion: @escaping (Result<ProductResponse, NetworkError>) -> Void){
        fetch(endpoint: "/products?limit=5", completion: completion)
    }
}

//import Foundation
//
//class NetworkManager {
//    static let shared = NetworkManager()
//    
//    private init() {}
//    private let baseURL = "https://dummyjson.com"
//    func fetch<T: Codable>(
//        endpoint: String,
//        completion: @escaping (Result<T, NetworkError>) -> Void
//    ){
//        guard let url = URL(string: baseURL + endpoint) else{
//            completion(.failure(.invalidURL))
//            return
//        }
//        //goi api
//        URLSession.shared.dataTask(with: url) {data, response, error in
//            if error != nil {
//                completion(.failure(.noData))
//                return
//            }
//            if let httpResponse = response as? HTTPURLResponse,
//               !(200...299).contains(httpResponse.statusCode) {
//                completion(.failure(.serverError(httpResponse.statusCode)))
//                return
//            }
//            guard let data = data else {
//                completion(.failure(.noData))
//                return
//            }
//            do {
//                let decoded = try JSONDecoder().decode(T.self, from: data)
//                DispatchQueue.main.async {
//                    completion(.success(decoded))
//                }
//            } catch {
//                print("Decoding error: \(error)")
//                completion(.failure(.decodingError))
//            }
//            
//        }.resume()
//    }

//}
