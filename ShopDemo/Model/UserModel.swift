//
//  UserModel.swift
//  ShopDemo
//
//  Created by gem on 27/3/26.
//
import Foundation

struct UserModel {
    let uid: String
    let email: String
    let username: String
    let phone: String
    let createdAt: Date
    
    var dictionary: [String: Any] {
        return [
            "uid": uid,
            "email": email,
            "username": username,
            "phone": phone,
            "createdAt": createdAt
        ]
    }
    
    init?(dictionary: [String: Any]) {
        guard let uid = dictionary["uid"] as? String,
              let email = dictionary["email"] as? String,
              let username = dictionary["username"] as? String,
              let phone = dictionary["phone"] as? String,
              let createdAt = dictionary["createdAt"] as? Date
        else { return nil }
        
        self.uid = uid
        self.email = email
        self.username = username
        self.phone = phone
        self.createdAt = createdAt
    }
    
    init(uid: String, email: String, username: String, phone: String) {
        self.uid = uid
        self.email = email
        self.username = username
        self.phone = phone
        self.createdAt = Date()
    }
}
