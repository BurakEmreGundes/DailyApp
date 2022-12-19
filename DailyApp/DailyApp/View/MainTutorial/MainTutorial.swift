//
//  MainTutorial.swift
//  DailyApp
//
//  Created by Burak Emre gündeş on 19.12.2022.
//

import UIKit

class MainTutorial: UIView, CarlaIBView {
    
    @IBOutlet weak var infoImageView: UIImageView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var subtitleText: UILabel!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    weak var delegate : MainTutorialViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func postInit() {
        configure()
    }
    
    func configure(image: UIImage?, titleText : String, descText : String ,tutorialCount : Int){
    
        self.infoImageView.image = image
        self.titleText.text = titleText
        self.subtitleText.text = descText
        
        if tutorialCount == 1 {
            nextButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        }
        
    }
    

    @IBAction func tappedNext(_ sender: Any) {
        delegate?.tappedNext()
    }
    
    @IBAction func tappedSkip(_ sender: Any) {
        delegate?.tappedSkip()
    }
    
    private func configure(){
        topView.layer.cornerRadius = 2.0
    }
}


protocol MainTutorialViewDelegate : AnyObject{
    func tappedNext()
    func tappedSkip()
}
