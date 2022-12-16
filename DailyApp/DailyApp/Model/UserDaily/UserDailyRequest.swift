//
//  UserDailyRequest.swift
//  DailyApp
//
//  Created by Burak Emre gündeş on 16.12.2022.
//

import Foundation

struct UserDailyRequest : Codable {
    var user : String
    var dailies : [Daily]
}
