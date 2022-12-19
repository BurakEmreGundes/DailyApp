//
//  HomeTableViewCell.swift
//  DailyApp
//
//  Created by Burak Emre gündeş on 17.12.2022.
//

import UIKit

class HomeTableViewCell: UITableViewCell, ClassNameGettable {
    
    static let cellId = "HomeTableViewCell"
    
    @IBOutlet weak var checkButton: UIButton!
   
    @IBOutlet weak var dailyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        checkButton.setTitle("", for: .normal)
        // Initialization code
    }

    
    private func createStrikeLabel(baseText : String) -> NSMutableAttributedString{
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: baseText)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributeString.length))
        
        return attributeString
    }
    
     func configureCell(text: String, isCompleted: Bool){
        
        /* if isCompleted{
             dailyLabel.attributedText = createStrikeLabel(baseText: text)
         }else{
             let attr = NSMutableAttributedString(string: text)
             attr.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSMakeRange(0,attr.length))
             dailyLabel.text = text
         }*/
         
         dailyLabel.text = text
    
        checkButton.setImage(UIImage(systemName: isCompleted ? "checkmark.circle.fill" : "circle"), for: .normal)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
