//
//  UserDailyResponse.swift
//  DailyApp
//
//  Created by Burak Emre gündeş on 17.12.2022.
//

import Foundation


struct UserDailyResponse : Codable {
    let success : Bool
    let data : [Daily]
}


