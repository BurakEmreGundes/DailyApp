//
//  ExtraDailyViewController.swift
//  DailyApp
//
//  Created by Burak Emre gündeş on 14.12.2022.
//

import UIKit

class ExtraDailyViewController: UIViewController {

    
    var extraDailyList : [DailyChallenge] = []{
        didSet{
            tableView.reloadData()
        }
    }
    
    //var textFieldText
    
    @IBOutlet weak var dailyTextField: UITextField!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        // Do any additional setup after loading the view.
    }
    
    private func configure(){
        configureTableView()
        configureLayoutAttributes()
        configureNavigationBar()
    }
    
    private func configureLayoutAttributes(){
        finishButton.layer.cornerRadius = 12.0
    }
    
    private func configureNavigationBar(){
        self.navigationItem.title = "Görev Ekle"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.backBarButtonItem?.title = nil
        title = nil
    }
    
 
    
    @IBAction func tappedAddButton(_ sender: Any) {
        
        guard let message = dailyTextField.text, !message.isEmpty else {
           let alert = AlertManager.shared.createBaseAlert(title: "Hata", message: "Lütfen, Boş Bırakmayınız.", buttonText: "Tamam")
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        extraDailyList.append(DailyChallenge(id: "21421", message: message, isChecked: false))
        
    }
    
    @IBAction func tappedFinishButton(_ sender: Any) {
        AlertManager.shared.delegate = self
       let alert = AlertManager.shared.createMultipleAlert(title: "Hatırlatma", message: "Görev seçim ve ekleme işlemleri bittikten sonra tekrardan seçim yapmak için baştan başlamanız gerekmektedir. Eğer baştan başlatmazsanız 7 gün boyunca seçtiğiniz görevlere göre atama yapılacaktır. Süre sonunda sistem otomatik olarak görevleri sıfırlayacaktır.", buttonOneText: "Seçime Devam Et", buttonTwoText: "Tamam")
        
        self.present(alert, animated: true, completion: nil)
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



}


extension ExtraDailyViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DailyListTableViewCell", for: indexPath) as? DailyListTableViewCell else {return UITableViewCell()}
        cell.configureCell(cellId: extraDailyList[indexPath.row].id, dailyLabel: extraDailyList[indexPath.row].message , isCheckout: extraDailyList[indexPath.row].isChecked, type: .extraDailyList)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return extraDailyList.count
    }
    
    
}

extension ExtraDailyViewController : AlertManagerTwoActionDelegate {
    func tappedContunie() {}
    
    func tappedCancel() {
        let sb = UIStoryboard(name: "Home", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "homeVC") as? HomeViewController else { return }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension ExtraDailyViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
    }
}
