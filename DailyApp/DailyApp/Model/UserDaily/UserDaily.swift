//
//  UserDaily.swift
//  DailyApp
//
//  Created by Burak Emre gündeş on 17.12.2022.
//

import Foundation

struct UserDaily : Codable {
    let _id : String
    let user : String
    let dailies : [Daily]
}
