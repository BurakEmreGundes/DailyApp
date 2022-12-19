//
//  CarlaIBView.swift
//  DailyApp
//
//  Created by Burak Emre gündeş on 19.12.2022.
//

import Foundation
import UIKit

protocol CarlaIBView: UIView {
    var contentView: UIView! { get }
    var nibName: String { get }
    func commonInit()
    func postInit()
}

extension CarlaIBView {
    func commonInit() {
        Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
        contentView?.fix(in: self)
        postInit()
    }
    
    func alternativeCommonInitForIBDesignable() {
        let bundle = Bundle(for: Self.self)
        bundle.loadNibNamed(nibName, owner: self, options: nil)
        contentView?.fix(in: self)
        postInit()
    }
    
    var nibName: String {
        let baseStr = String(reflecting: type(of: self))
        return baseStr.replacingOccurrences(of: "DailyApp.", with: "")
    }
    
    func postInit() { }
}

