//
//  Daily.swift
//  DailyApp
//
//  Created by Burak Emre gündeş on 14.12.2022.
//

import Foundation


class Daily : Codable {
    let _id : String
    let message : String
    let isChecked : Bool
    let isBase : Bool
    var isCompleted : Bool
}


struct DailyResponse : Codable {
    let data : [Daily]
    let success : Bool
}

struct CreateDailyResponse : Codable {
    let data : Daily
    let success : Bool
}

struct DeleteDailyResponse : Codable {
    let data : Daily
    let success : Bool
}

