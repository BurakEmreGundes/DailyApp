//
//  UITableView.swift
//  DailyApp
//
//  Created by Burak Emre gündeş on 14.12.2022.
//

import Foundation
import UIKit

extension UITableView{
    func register(with commonId: String) {
        register(UINib(nibName: commonId, bundle: nil), forCellReuseIdentifier: commonId)
    }
}
