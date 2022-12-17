//
//  User.swift
//  DailyApp
//
//  Created by Burak Emre gündeş on 16.12.2022.
//

import Foundation


class User:Codable {
    var _id : String?

    
    var userId : String? {
        get {
            return UserDefaults.standard.string(forKey: "userId")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "userId")
        }
    }
    
    
    var userDidStartDailyChallenge : Bool {
        get {
            return UserDefaults.standard.bool(forKey: "userDidStartDailyChallenge")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "userDidStartDailyChallenge")
        }
    }
    

    static var current: User = User()
    private init() { }
}



