//
//  LoginViewController.swift
//  ShopDemo
//
//  Created by gem on 27/3/26.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var savePassw: UISwitch!
    @IBOutlet weak var stView: UIStackView!
    @IBOutlet weak var loginBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
 
    }
    func setupUI(){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.passwordTF.frame.height))
        stView.layer.cornerRadius = 32
        
        emailTF.layer.cornerRadius = 22
        emailTF.layer.borderWidth = 1
        emailTF.leftView = paddingView
        emailTF.leftViewMode = .always
        addIconToTextField(textField: emailTF, systemImageName: "person.fill")
        
        passwordTF.layer.cornerRadius = 22
        passwordTF.layer.borderWidth = 1
        passwordTF.leftView = paddingView
        passwordTF.leftViewMode = .always
        addIconToTextField(textField: passwordTF, systemImageName: "lock")
        
        loginBtn.layer.cornerRadius = 24
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Thông báo",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        guard let email = emailTF.text, !email.isEmpty,
              let password = passwordTF.text, !password.isEmpty else {
            showAlert(message: "Vui lòng nhập đầy đủ thông tin!")
            return
        }
        
        // Loading indicator
        loginBtn.isEnabled = false
        loginBtn.setTitle("Đang đăng nhập...", for: .normal)
        
        AuthManager.shared.login(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.loginBtn.isEnabled = true
                self?.loginBtn.setTitle("Login Account", for: .normal)
                
                switch result {
                case .success(let user):
                    print("Login thành công: \(user.username)")
                    self?.navigateToMain()
                case .failure(let error):
                    self?.showAlert(message: error.localizedDescription)
                }
            }
        }
    }
    
    private func navigateToMain() {
        guard let windowScene = UIApplication.shared.connectedScenes.first
                as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        window.rootViewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateInitialViewController()
        UIView.transition(with: window,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: nil)
    }
    
    func addIconToTextField(textField: UITextField, systemImageName: String) {
        let iconView = UIImageView(frame: CGRect(x: 10, y: 5, width: 20, height: 20))
        iconView.image = UIImage(systemName: systemImageName)
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .systemGray
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 30))
        paddingView.addSubview(iconView)
        
        textField.leftView = paddingView
        textField.leftViewMode = .always
    }
}

