//
//  UINavigationController.swift
//  DailyApp
//
//  Created by Burak Emre gündeş on 14.12.2022.
//

import UIKit

extension UINavigationController{
    
    func configureNavigationForBase() {
        navigationBar.tintColor = .systemOrange
        //navigationBar.backIndicatorImage = UIImage(named: "arrowback")
        //navigationBar.backItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.backgroundColor = .lightGray
            navBarAppearance.backgroundEffect = nil
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.systemOrange, .font: UIFont.boldSystemFont(ofSize: 22)]
            navigationBar.scrollEdgeAppearance = navBarAppearance
            navigationBar.standardAppearance = navBarAppearance
        }
    }
}
