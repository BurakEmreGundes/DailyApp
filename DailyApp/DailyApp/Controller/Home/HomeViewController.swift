//
//  HomeViewController.swift
//  DailyApp
//
//  Created by Burak Emre gündeş on 15.12.2022.
//

import UIKit

class HomeViewController: UIViewController {

    private lazy var containerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isDirectionalLockEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.isUserInteractionEnabled = true
        return scrollView
    }()
    
    private lazy var mainView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var mainStackView : UIStackView = {
        let sv = UIStackView(arrangedSubviews: [scoreView])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.alignment = .fill
        sv.distribution = .fill
        sv.axis = .vertical
        sv.spacing = 16
        return sv
    }()
    
    private lazy var scoreView : UIView = {
        let view = UIView()
        view.backgroundColor = .systemOrange
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12.0
        return view
    }()
    
    private lazy var scoreLabel : UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Toplam Skorun : 892p"
        label.textColor = .label
        label.font = .systemFont(ofSize: 18.0, weight: .bold)
       return label
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
        view.addSubview(containerView)
        containerView.addSubview(scrollView)
        scrollView.addSubview(mainView)
        mainView.addSubview(mainStackView)
        scoreView.addSubview(scoreLabel)
        
        view.layoutSubviews()
        view.layoutIfNeeded()
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            
            scrollView.topAnchor.constraint(equalTo: containerView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            
            mainView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            mainView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            
            mainView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            mainStackView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 16),
            mainStackView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -16),
            
            scoreView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.1),
            
            scoreLabel.leadingAnchor.constraint(equalTo: scoreView.leadingAnchor,constant: 16),
            scoreLabel.trailingAnchor.constraint(equalTo: scoreView.trailingAnchor,constant: -16),
            scoreLabel.centerYAnchor.constraint(equalTo: scoreView.centerYAnchor)
            
            
        ])
        
    }
    
    private func configureNavigationBar(){
        self.navigationItem.title = "Görevlerim"
        self.navigationController?.configureNavigationForBase()
    }
    

}

extension HomeViewController : UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.x = 0
    }
}
