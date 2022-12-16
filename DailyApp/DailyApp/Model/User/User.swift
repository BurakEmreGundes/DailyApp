//
//  User.swift
//  DailyApp
//
//  Created by Burak Emre gündeş on 16.12.2022.
//

import Foundation


class User:Codable {
    var _id : String?

    var JWTToken: String? {
        get {
            return UserDefaults.standard.string(forKey: "JWTToken")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "JWTToken")
        }
    }
    

    static var current: User = User()
    private init() { }
}



