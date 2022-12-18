//
//  HomeViewController.swift
//  DailyApp
//
//  Created by Burak Emre gündeş on 15.12.2022.
//

import UIKit

class HomeViewController: UIViewController {
    
    private var dailyList : [Daily] = [] {
        didSet{
            configureListForDay()
        }
    }
    
    
    private var listForDay : [ListForDayUIModel] = []
    
    private var tableViewDatas : [Daily] = [] {
        didSet{
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else {return}
                    strongSelf.tableView.reloadData()
                }
        }
    }
    
    private var lastExtraIndexes : Int = 0

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
        let sv = UIStackView(arrangedSubviews: [scoreTitleLabel,scoreView, dailyTitleLabel, daysContainerView, tableView])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.alignment = .fill
        sv.distribution = .fill
        sv.axis = .vertical
        sv.spacing = 16
        return sv
    }()
    
    private lazy var scoreTitleLabel : UILabel = {
        let label = UILabel()
         label.translatesAutoresizingMaskIntoConstraints = false
         label.text = "Skorum"
         label.textColor = .label
         label.font = .systemFont(ofSize: 28.0, weight: .bold)
        return label
    }()
    
    private lazy var scoreView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 2.0
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
    
    private lazy var dailyTitleLabel : UILabel = {
        let label = UILabel()
         label.translatesAutoresizingMaskIntoConstraints = false
         label.text = "Görevlerim"
         label.textColor = .label
         label.font = .systemFont(ofSize: 28.0, weight: .bold)
        return label
    }()
    
    
    private lazy var daysContainerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private lazy var dayView : DayView = {
        let view = DayView()
        view.configure(dayCount: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    private lazy var dayView2 : DayView = {
        let view = DayView()
        view.configure(dayCount: 2)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    private lazy var dayView3 : DayView = {
        let view = DayView()
        view.configure(dayCount: 3)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    private lazy var dayView4 : DayView = {
        let view = DayView()
        view.configure(dayCount: 4)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    private lazy var dayView5 : DayView = {
        let view = DayView()
        view.configure(dayCount: 5)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    private lazy var dayView6 : DayView = {
        let view = DayView()
        view.configure(dayCount: 6)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    private lazy var dayView7 : DayView = {
        let view = DayView()
        view.configure(dayCount: 7)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    private lazy var dayStackView : UIStackView = {
        let sv = UIStackView(arrangedSubviews: [dayView, dayView2, dayView3, dayView4, dayView5, dayView6, dayView7])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.alignment = .fill
        sv.distribution = .fillEqually
        sv.axis = .horizontal
        sv.spacing = 6
        return sv
    }()
    
    
    private lazy var tableView : UITableView = {
       let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(with: HomeTableViewCell.className)
        return tableView
    }()
    
    private func getAllUserDailies(){
        guard let userDailyId = User.current.userDailyId else {return}
        
        GetUserDailies(id: userDailyId).execute {[weak self] response in
            guard let strongSelf = self else {return}
            switch response{
            case .this(let success):
                strongSelf.dailyList = success.data.dailies
            case .that(let error):
                print(error)
            }
        } onError: { error in
            print(error)
        }

    }
    
    
    private func configureDayCount(){
        dayView.tapped()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllUserDailies()
        configure()
        configureDayCount()
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
        containerView.addSubview(mainView)
        //scrollView.addSubview(mainView)
        mainView.addSubview(mainStackView)
        scoreView.addSubview(scoreLabel)
        
        daysContainerView.addSubview(dayStackView)
        
        view.layoutSubviews()
        view.layoutIfNeeded()
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                        
            mainView.topAnchor.constraint(equalTo: containerView.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            mainView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            mainView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            mainStackView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 16),
            mainStackView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -16),
            
            scoreView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.1),
            
            scoreLabel.leadingAnchor.constraint(equalTo: scoreView.leadingAnchor,constant: 16),
            scoreLabel.trailingAnchor.constraint(equalTo: scoreView.trailingAnchor,constant: -16),
            scoreLabel.centerYAnchor.constraint(equalTo: scoreView.centerYAnchor),

            dayStackView.topAnchor.constraint(equalTo: daysContainerView.topAnchor),
            dayStackView.leadingAnchor.constraint(equalTo: daysContainerView.leadingAnchor),
            dayStackView.trailingAnchor.constraint(equalTo: daysContainerView.trailingAnchor),
            dayStackView.bottomAnchor.constraint(equalTo: daysContainerView.bottomAnchor),
                        
        ])
        
        mainStackView.setCustomSpacing(28, after: scoreView)
        
    }
    
    private func configureNavigationBar(){
        self.navigationItem.title = "Haftalık Durumum"
        self.navigationController?.configureNavigationForBase()
    }
    
    
    private func configureListForDay(){
       
        if dailyList.count > 7 {
        for dayLevel in 1...7{
            
                let itemCountForDay = ((dailyList.count - (dailyList.count % 7)) / 7)
                let startIndex = (dayLevel * itemCountForDay) - 1
                let endIndex = (startIndex + itemCountForDay) - 1
                let extraIndexes = (dailyList.count % 7)
                var excDailyList : [Daily] = []
              
                
                for selectedIndex in startIndex...endIndex{
                    excDailyList.append(dailyList[selectedIndex])
                }
              
                lastExtraIndexes = lastExtraIndexes > 0 ? (lastExtraIndexes - 1) : extraIndexes
                
                if lastExtraIndexes > 0, dayLevel <= extraIndexes {
                    excDailyList.append(dailyList[dailyList.count - lastExtraIndexes])
                }
                
                listForDay.append(ListForDayUIModel(dailies: excDailyList))
                
            }
             
        }else{
            for dayLevel in 1...7{
                var excDailyList : [Daily] = []
                if dayLevel > dailyList.count {
                listForDay.append(ListForDayUIModel(dailies: []))
                 
                }else{
                    excDailyList.append(dailyList[dayLevel - 1])
                    listForDay.append(ListForDayUIModel(dailies: excDailyList))
                }
               
            }
        }
        
        tableViewDatas = listForDay[0].dailies

    }
    

}

extension HomeViewController : UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.x = 0
    }
}


extension HomeViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as? HomeTableViewCell else {return UITableViewCell()}
        cell.configureCell(text: tableViewDatas[indexPath.row].message, isCompleted: tableViewDatas[indexPath.row].isCompleted)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewDatas.count
    }
}

extension HomeViewController : DayViewDelegate {
    func tapped(dayLevel: Int) {
        dayStackView.arrangedSubviews.forEach { view in
            if let view = view as? DayView {

                if listForDay.count > 0 {
                    
                    tableViewDatas =  listForDay[dayLevel - 1].dailies
                   
                }
              
                
                if view.dayLevel == dayLevel {
                    view.setColor(color: .carlaBlueSky, textColor : .white, borderColor : .white)
                }else{
                    view.setColor(color: .clear, textColor : .label, borderColor : .label)
                }
            }
        }
      
    }
}
