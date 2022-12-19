//
//  SharedExtensions.swift
//  DailyApp
//
//  Created by Burak Emre gündeş on 16.12.2022.
//

import Foundation
import UIKit

extension Encodable {
    func asDictionary() -> Dictionary<String, Any>? {
        guard let data = try? JSONEncoder().encode(self) else {
            #if DEBUG
            print("Error encoding codable object.")
            #endif
            return nil
        }
        guard let dictionary = ((try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]) as [String : Any]??) else {
            #if DEBUG
            print("Error serializing codable object.")
            #endif
            return nil
        }
        return dictionary
    }
}


extension UIViewController {
    
    
    /// This method can be called in any controller's viewDidLoad to hide keyboard
    /// when tapped outside of it.
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}


extension UIView{
    func fix(in container: UIView, offset: CGFloat = 0, shouldAddAsSubview: Bool = true) {
        self.translatesAutoresizingMaskIntoConstraints = false;
        if shouldAddAsSubview {
            self.frame = container.frame
            container.addSubview(self)
        }
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: offset).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: -offset).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: offset).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: -offset).isActive = true
    }
    
    func fix(in container: UIView, verticalOffset: CGFloat, horizontalOffset: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: horizontalOffset).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: -horizontalOffset).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: verticalOffset).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: -verticalOffset).isActive = true
    }
}
