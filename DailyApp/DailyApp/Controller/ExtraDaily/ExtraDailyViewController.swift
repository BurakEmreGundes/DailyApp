//
//  ExtraDailyViewController.swift
//  DailyApp
//
//  Created by Burak Emre gündeş on 14.12.2022.
//

import UIKit

class ExtraDailyViewController: UIViewController {

    var extraDailyList : [Daily] = UserCustomDailyManager.shared.customDailies
    
    var selectedBaseDailies : [Daily] = [] 
    
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
        UserCustomDailyManager.shared.delegate = self
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
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.tableView.reloadData()
        }

        self.navigationItem.backBarButtonItem?.title = nil
        title = nil
    }
    
 
    
    @IBAction func tappedAddButton(_ sender: Any) {
        
        guard let message = dailyTextField.text, !message.isEmpty else {
           let alert = AlertManager.shared.createBaseAlert(title: "Hata", message: "Lütfen, Boş Bırakmayınız.", buttonText: "Tamam")
            self.present(alert, animated: true, completion: nil)
            
            return
        }
                
        UserCustomDailyManager.shared.createCustomDaily(dailyRequest: DailyRequest(message: message, isBase: false))
        
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
    
    
    private func goToHomeScreen(){
        let sb = UIStoryboard(name: "Home", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "homeVC") as? HomeViewController else { return }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
   
    

}


extension ExtraDailyViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DailyListTableViewCell", for: indexPath) as? DailyListTableViewCell else {return UITableViewCell()}
        cell.configureCell(cellId: extraDailyList[indexPath.row]._id, dailyLabel: extraDailyList[indexPath.row].message , isCheckout: extraDailyList[indexPath.row].isChecked, type: .extraDailyList)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return extraDailyList.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            UserCustomDailyManager.shared.deleteCustomDaily(daily: extraDailyList[indexPath.row])
            extraDailyList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension ExtraDailyViewController : AlertManagerTwoActionDelegate {
    func tappedContunie() {

    }
    
    func tappedCancel() {
        guard let userId = User.current.userId else {return}
               
        selectedBaseDailies.insert(contentsOf: extraDailyList, at: selectedBaseDailies.count) 
        
        let allDailies : [Daily] = selectedBaseDailies
        
        CreateUserDaily(userDailyRequest: UserDailyRequest(user: userId, dailies: allDailies)).execute {[weak self] response in
            guard let strongSelf = self else {return}
            switch response{
            case .this(let success):
                strongSelf.selectedBaseDailies.insert(contentsOf: strongSelf.extraDailyList, at: strongSelf.selectedBaseDailies.count)
                User.current.userDidStartDailyChallenge = true
                User.current.userDailyId = success.data._id
                strongSelf.goToHomeScreen()
            case .that(let error):
                print(error)
            }
        } onError: { error in
            print(error)
        }
    }
    
    
}

extension ExtraDailyViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
    }
}

extension ExtraDailyViewController : UserCustomDailyManagerDelegate {
    func setCustomDailies(customDailies: [Daily]) {
        self.extraDailyList = customDailies
        self.tableView.reloadData()
    }
}
