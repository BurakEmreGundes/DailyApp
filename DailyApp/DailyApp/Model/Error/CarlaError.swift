//
//  CarlaError.swift
//  DailyApp
//
//  Created by Burak Emre gündeş on 16.12.2022.
//


import Foundation

enum CarlaError: Error {
    case userPrivateKeyRetrievalFailure
    case userPrivateKeyCastFailure
    case couldNotDecodeEither(thisError: Error, thatError: Error)
}
