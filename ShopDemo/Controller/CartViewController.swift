//
//  CartViewController.swift
//  ShopDemo
//
//  Created by gem on 19/3/26.
//

import UIKit

class CartViewController: UIViewController {

    @IBOutlet weak var tableViewCart: UITableView!
    @IBOutlet weak var totalPriceLbl: UILabel!
    @IBOutlet weak var checkOutBtn: UIButton!

    
    var items  = CartManager.shared.cartItems
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadCart()
        tableViewCart.delegate = self
        tableViewCart.dataSource = self
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(cartUpdated),
            name: .cartUpdated,
            object: nil
        )
    }

    func setupUI() {
        checkOutBtn.layer.cornerRadius = 8

    }

    func loadCart() {
        items = CartManager.shared.cartItems
        totalPriceLbl.text = "$\(String(format: "%.2f", CartManager.shared.totalPrice()))"
        tableViewCart.reloadData()
    }
    
    @objc func cartUpdated() {
        DispatchQueue.main.async {
            self.loadCart()
        }
    }
    
    @IBAction func checkOutTapped(_ sender: UIButton) {
        showAlert(message: "Thanh toán thành công, có thể đánh giá")
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Thông báo",message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension CartViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
        cell.configure(with: items[indexPath.row])
        return cell
    }
    
        
}
extension NSNotification.Name {
    static let cartUpdated = NSNotification.Name("cartUpdated")
}
