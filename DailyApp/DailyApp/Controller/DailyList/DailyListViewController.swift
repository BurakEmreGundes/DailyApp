//
//  DailyListViewController.swift
//  DailyApp
//
//  Created by Burak Emre gündeş on 14.12.2022.
//

import UIKit

class DailyListViewController: UIViewController {
    
    var dailyList : [Daily]? {
        didSet{
            tableView.reloadData()
        }
    }
     
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var finishSelectButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        getDailies()
        configure()
    }
    
    private func configure(){
        configureTableView()
        configureNavBar()
        configureLayoutAttributes()
    }
    
    private func getDailies(){
        GetDailies().execute { [weak self] response in
            guard let strongSelf = self else {return}
            switch response {
                case .this(let success):
                strongSelf.dailyList = success.data
                case .that(let error):
                print(error)
            }
        } onError: { error in
            print(error)
        }

    }
    
    
    private func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(with: DailyListTableViewCell.className)
    }
    
    private func configureNavBar(){
        self.navigationItem.title = "Görev Seç"
        self.navigationController?.configureNavigationForBase()
    }
    
    private func configureLayoutAttributes(){
        finishSelectButton.layer.cornerRadius = 12.0
    }

    @IBAction func selectButtonTapped(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "extraDailyVC") as? ExtraDailyViewController else { return }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension DailyListViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let dailyList = dailyList else {return UITableViewCell()}
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DailyListTableViewCell", for: indexPath) as? DailyListTableViewCell else {return UITableViewCell()}
        cell.configureCell(cellId: dailyList[indexPath.row]._id, dailyLabel: dailyList[indexPath.row].message, isCheckout: dailyList[indexPath.row].isChecked)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let dailyList = dailyList else {return}
       // dailyList[indexPath.row].isChecked = !dailyList[indexPath.row].isChecked
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyList?.count ?? 0
    }
    
    
}
