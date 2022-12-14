//
//  DailyListViewController.swift
//  DailyApp
//
//  Created by Burak Emre gündeş on 14.12.2022.
//

import UIKit

class DailyListViewController: UIViewController {
    
    var dailyChallengeList : [DailyChallenge] = [DailyChallenge(id: "1234", message: "Dişini Fırçala", isChecked: true),DailyChallenge(id: "1235", message: "Yatağını Topla", isChecked: false), DailyChallenge(id: "1237", message: "Kapıyı Kapat", isChecked: true), DailyChallenge(id: "1238", message: "Yüzünü Yıka", isChecked: false), DailyChallenge(id: "1239", message: "Çamaşırları Topla", isChecked: false), DailyChallenge(id: "1240", message: "Soda İç", isChecked: false), DailyChallenge(id: "1241", message: "Camı Kapat", isChecked: true), DailyChallenge(id: "1234", message: "Ütüyü fişten çek", isChecked: false),DailyChallenge(id: "1333", message: "Dişini Fırçala", isChecked: true),DailyChallenge(id: "1334", message: "Yatağını Topla", isChecked: false), DailyChallenge(id: "1335", message: "Kapıyı Kapat", isChecked: true), DailyChallenge(id: "1336", message: "Yüzünü Yıka", isChecked: false), DailyChallenge(id: "1337", message: "Çamaşırları Topla", isChecked: false), DailyChallenge(id: "1338", message: "Soda İç", isChecked: false), DailyChallenge(id: "1339", message: "Camı Kapat", isChecked: true), DailyChallenge(id: "1310", message: "Ütüyü fişten çek", isChecked: false),DailyChallenge(id: "1444", message: "Dişini Fırçala", isChecked: true),DailyChallenge(id: "1445", message: "Yatağını Topla", isChecked: false), DailyChallenge(id: "1446", message: "Kapıyı Kapat", isChecked: true), DailyChallenge(id: "1447", message: "Yüzünü Yıka", isChecked: false), DailyChallenge(id: "1448", message: "Çamaşırları Topla", isChecked: false), DailyChallenge(id: "1449", message: "Soda İç", isChecked: false), DailyChallenge(id: "1410", message: "Camı Kapat", isChecked: true), DailyChallenge(id: "1411", message: "Ütüyü fişten çek", isChecked: false)
    ] {
        didSet{
            tableView.reloadData()
        }
    }
     
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var finishSelectButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure(){
        configureTableView()
        configureNavBar()
        configureLayoutAttributes()
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
    }
    
    private func configureLayoutAttributes(){
        finishSelectButton.layer.cornerRadius = 12.0
    }

    @IBAction func selectButtonTapped(_ sender: Any) {
        print("select button tapped")
    }
    
}

extension DailyListViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DailyListTableViewCell", for: indexPath) as? DailyListTableViewCell else {return UITableViewCell()}
        cell.configureCell(cellId: dailyChallengeList[indexPath.row].id, dailyLabel: dailyChallengeList[indexPath.row].message, isCheckout: dailyChallengeList[indexPath.row].isChecked)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dailyChallengeList[indexPath.row].isChecked = !dailyChallengeList[indexPath.row].isChecked
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyChallengeList.count
    }
    
    
}
