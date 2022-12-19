//
//  AlertPopupViewController.swift
//  DailyApp
//
//  Created by Burak Emre gündeş on 19.12.2022.
//

import UIKit


class AlertPopupViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet private weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var imageViewTopConstraint: NSLayoutConstraint!
    
    private static let defaultCornerRadius: CGFloat = 4
    private static let defaultImageHeight: CGFloat = 60
    
    private var action: ((AlertPopupViewController?) -> Void)?
    
    private func configure(headTitle: String?, text: String, buttonText: String, backgroundColor: UIColor, cornerRadius: CGFloat, imageHeight: CGFloat,
                           buttonBackgroundColor: UIColor, image: UIImage?,
                           action: ((AlertPopupViewController?) -> Void)?) {
        view?.layer.cornerRadius = cornerRadius
        button.layer.cornerRadius = 4
        imageViewHeightConstraint.constant = imageHeight
        updateImage(image: image)
        self.action = action
        if let title = headTitle {
            titleLabel.isHidden = false
            titleLabel.text = title
        }
        label.configureLabel(color: .slateGrey, font: UIFont.systemFont(ofSize: 18))
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        
        view.backgroundColor = backgroundColor
        button.backgroundColor = buttonBackgroundColor
        button.setText(text: buttonText)
        
        label.text = text
        view.layoutIfNeeded()
    }
    
    private func updateImage(image: UIImage?) {
        guard let newImage = image else {
            imageViewHeightConstraint.constant = 0
            imageViewTopConstraint.constant = 0
            return
        }
        imageView.image = newImage
    }
    
    @IBAction func tappedButton(_ sender: UIButton) {
        weak var weakSelf = self
        action?(weakSelf)
    }
    
    static func popup(headTitle: String? = nil, text: String, image: UIImage? = nil, cornerRadius: CGFloat = AlertPopupViewController.defaultCornerRadius, imageHeight: CGFloat = AlertPopupViewController.defaultImageHeight ,action: ((AlertPopupViewController?) -> Void)? = nil,
                      buttonText: String = "Tamam", backgroundColor: UIColor = .white,
                      buttonBackgroundColor: UIColor = .carlaBlueSky) -> AlertPopupViewController {
        let vc = AlertPopupViewController(nibName: "AlertPopupViewController", bundle: nil)
        vc.loadViewIfNeeded()
        vc.configure(headTitle: headTitle, text: text,
                     buttonText: buttonText,
                     backgroundColor: backgroundColor,
                     cornerRadius: cornerRadius, imageHeight: imageHeight, buttonBackgroundColor: buttonBackgroundColor,
                     image: image,
                     action: action)
        return vc
    }
}

