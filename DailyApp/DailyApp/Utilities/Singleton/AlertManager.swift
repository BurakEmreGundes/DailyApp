//
//  AlertManager.swift
//  DailyApp
//
//  Created by Burak Emre gündeş on 15.12.2022.
//

import Foundation
import UIKit


class AlertManager {
    
    static let shared = AlertManager()
    
    weak var delegate: AlertManagerTwoActionDelegate?
    
    func createBaseAlert(title: String, message: String, buttonText: String) -> UIAlertController{
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        
        alert.addAction(UIAlertAction(title: buttonText, style: UIAlertAction.Style.default, handler: nil))
        
        return alert
    }
    
    
    func createMultipleAlert(title: String, message: String, buttonOneText: String, buttonTwoText: String) -> UIAlertController{

             let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

        
        alert.addAction(UIAlertAction(title: buttonOneText, style: UIAlertAction.Style.default, handler: { [weak self] action in
            guard let strongSelf = self else {return}
            strongSelf.delegate?.tappedContunie()
        }))
        alert.addAction(UIAlertAction(title: buttonTwoText, style: UIAlertAction.Style.destructive, handler: { [weak self] action in
            guard let strongSelf = self else {return}
            strongSelf.delegate?.tappedCancel()
        }))
        
        return alert

    }
    
    
}

protocol AlertManagerTwoActionDelegate: AnyObject{
    func tappedContunie()
    func tappedCancel()
}
