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
    
    var selectedDailies : [Daily] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var tutorialCount : Int = 0
    
     
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var finishSelectButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        if !(User.current.userDidShowTutorialPage) {
            showTutorial(contentView: mainTutorialView)
        }
        getDailies()
        configure()
    }
    
    private lazy var mainTutorialView : MainTutorial = {
        let view = MainTutorial()
        view.delegate = self
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private func showTutorial(contentView : UIView){
        User.current.userDidShowTutorialPage = true
        let bottomSheetViewController = BottomSheetController(contentView: contentView, title: "" ,overrideTitle: false, bottomConstraint: 0)
        bottomSheetViewController.cornerRadius = 12
        bottomSheetViewController.delegate = self
        bottomSheetViewController.isStackViewHidden = true

        self.present(bottomSheetViewController, animated: true, completion: nil)
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
    
    
    private func goToExtraDailyVC(selectedBaseDailies : [Daily]){
         let sb = UIStoryboard(name: "Main", bundle: nil)
         guard let vc = sb.instantiateViewController(withIdentifier: "extraDailyVC") as? ExtraDailyViewController else { return }
         
        vc.selectedBaseDailies = selectedBaseDailies
         self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func selectButtonTapped(_ sender: Any) {
        guard let _ = User.current.userId else {return}
        goToExtraDailyVC(selectedBaseDailies: selectedDailies)
    }
    
}

extension DailyListViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let dailyList = dailyList else {return UITableViewCell()}
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DailyListTableViewCell", for: indexPath) as? DailyListTableViewCell else {return UITableViewCell()}
        
        cell.configureCell(cellId: dailyList[indexPath.row]._id, dailyLabel: dailyList[indexPath.row].message, isCheckout: selectedDailies.contains(where: {$0._id == dailyList[indexPath.row]._id }))
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let dailyList = dailyList else {return}
        if selectedDailies.contains(where: {$0._id == dailyList[indexPath.row]._id }){
            guard let index = self.selectedDailies.firstIndex(where: {$0._id == dailyList[indexPath.row]._id}) else {return}
            selectedDailies.remove(at: index)
        }else{
            selectedDailies.append(dailyList[indexPath.row])
        }
        selectedDailies.withUnsafeBufferPointer {_ in
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyList?.count ?? 0
    }
    
    
}

extension DailyListViewController : BottomSheetDelegate {
    func activateView() {
        view.isUserInteractionEnabled = true
    }
}

extension DailyListViewController : MainTutorialViewDelegate {
    func tappedNext() {
        mainTutorialView.configure(image: UIImage(named: "tutorialImage1.1"), titleText: "deneme", descText: "deneme", tutorialCount: tutorialCount)
        if tutorialCount < 2{
            tutorialCount += 1
            self.dismiss(animated: true)
            self.showTutorial(contentView: mainTutorialView)
        }else{
            self.dismiss(animated: true)
        }
    }
    
    func tappedSkip() {
        self.dismiss(animated: true)
    }
}
