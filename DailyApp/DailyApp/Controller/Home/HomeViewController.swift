//
//  HomeViewController.swift
//  DailyApp
//
//  Created by Burak Emre gündeş on 15.12.2022.
//

import UIKit

class HomeViewController: UIViewController {

    
    private lazy var mainView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        discardPopOperations()
    }
    
    private func discardPopOperations(){
        self.navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    private func configure(){
        configureLayoutAttributes()
        configureNavigationBar()
    }
    
    private func configureLayoutAttributes(){
       
    }
    
    private func configureNavigationBar(){
        self.navigationItem.title = "Görevlerim"
        self.navigationController?.configureNavigationForBase()
    }
    

}
