//
//  DailyListTableViewCell.swift
//  DailyApp
//
//  Created by Burak Emre gündeş on 14.12.2022.
//

import UIKit
enum DailListCellType{
    case dailyList
    case extraDailyList
}

class DailyListTableViewCell: UITableViewCell, ClassNameGettable {
    
    static let cellId = "DailyListTableViewCell"

    @IBOutlet weak var checkButtonImage: UIButton!
    @IBOutlet weak var dailyLabel: UILabel!
    
    var id : String = ""
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(cellId : String, dailyLabel : String, isCheckout: Bool, type: DailListCellType = .dailyList){
        
        self.id = cellId
        self.dailyLabel.text = dailyLabel
       
        switch type {
        case .dailyList:
            self.checkButtonImage.setImage(UIImage(systemName: isCheckout ? "checkmark.circle.fill" : "circle"), for: .normal)
        case .extraDailyList:
            self.checkButtonImage.isHidden = true
        }
    }
    
    @IBAction func tappedCheck(_ sender: Any) {
        //checkButtonImage.isHidden = !checkButtonImage.isHidden
    }
}
