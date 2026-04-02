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

    var items: [CartItem] {
            return CartManager.shared.cartItems
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(cartUpdated),
            name: .cartUpdated,
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        print("Cart bi huy")
    }
    func setUp() {
        checkOutBtn.layer.cornerRadius = 8
        
        tableViewCart.delegate = self
        tableViewCart.dataSource = self

    }
    //Update thong tin tu Home
    @objc func cartUpdated(_ notification : Notification) {
        guard let productInfo = notification.userInfo,
              let productID = productInfo["productID"] as? Int,
              let action = productInfo["action"] as? String else { return }
        
        DispatchQueue.main.async {
            switch action {
            case "update":
                print("them quantity")
                if let index = self.items.firstIndex(where: {$0.product.id == productID}) {
                    self.tableViewCart.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
                }
            case "add":
                let newIndexPath = IndexPath(row: self.items.count - 1, section: 0)
                self.tableViewCart.insertRows(at: [newIndexPath], with: .automatic)
            default:
                break
            }
        }
        
        totalPriceLbl.text = "$\(String(format: "%.2f", CartManager.shared.totalPrice()))"
    }
    
    //Thanh toan
    @IBAction func checkOutTapped(_ sender: UIButton) {
        let purchasedIDs = CartManager.shared.cartItems.map { $0.product.id }
        
        PurchaseManager.shared.addPurchased(productIDs: purchasedIDs)
        CartManager.shared.clearCart()
        showAlert(message: "Thanh toán thành công, có thể đánh giá")
        
        tableViewCart.reloadData()
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
        print("DEBUG: Quantity: \(items[indexPath.row].quantity)")
        cell.configure(with: items[indexPath.row])
        cell.delegate = self
        return cell
    }
}
// Nhan thong bao tu Cell
extension CartViewController : CartCellDelegate {
    func removeProduct(on cell: CartCell) {
        guard let indexPath = tableViewCart.indexPath(for: cell) else {return}
        CartManager.shared.removeItem(at: indexPath.row)
        tableViewCart.deleteRows(at: [indexPath], with: .left)
    }
    
    func didChangeQuantity(on cell: CartCell, isIncrease: Bool) {
        guard let indexPath = tableViewCart.indexPath(for: cell) else {return}
        
        if isIncrease == true {
            CartManager.shared.increaseQuantity(at: indexPath.row)
        }else {
            CartManager.shared.decreaseQuantity(at: indexPath.row)
        }
        
        tableViewCart.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .fade)
        
        let newQuantity = CartManager.shared.cartItems[indexPath.row].quantity
        if newQuantity > 0 {
            cell.updateQuantity(newQuantity)
        }

        totalPriceLbl.text = "$\(String(format: "%.2f", CartManager.shared.totalPrice()))"
    }
}

extension NSNotification.Name {
    static let cartUpdated = NSNotification.Name("cartUpdated")
}
