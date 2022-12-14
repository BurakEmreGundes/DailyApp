//
//  ClassNameGettable.swift
//  DailyApp
//
//  Created by Burak Emre gündeş on 14.12.2022.
//

import Foundation

public protocol ClassNameGettable {
    static var className: String { get }
    var className: String { get }
}

public extension ClassNameGettable {
    static var className: String {
        return String(describing: self)
    }

    var className: String {
        return type(of: self).className
    }
}
