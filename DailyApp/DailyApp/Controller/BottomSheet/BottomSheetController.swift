//
//  BottomSheetController.swift
//  DailyApp
//
//  Created by Burak Emre gündeş on 19.12.2022.
//

import Foundation


import UIKit

class BottomSheetController: UIViewController {
    private(set) public var contentController: UIViewController?

    private(set) public var contentView: UIView?

    public var cornerRadius: CGFloat = 0

    private var containerView = UIView()

    private var titleText: String?
    
    var delegate: BottomSheetDelegate?
    
    private var overrideTitle: Bool?
    
    private var bottomConstraint: Int?
    
    var isStackViewHidden: Bool?

    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, closeButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.spacing = 0
        return stackView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = " "
        label.lineBreakMode = .byTruncatingMiddle
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "iconClose"), for: .normal)
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        button.widthAnchor.constraint(equalToConstant: 43).isActive = true
        button.addTarget(self, action: #selector(tappedCloseButton(_:)), for: .touchUpInside)
        return button
    }()

    public init(contentController: UIViewController, title: String) {
        super.init(nibName: nil, bundle: nil)
        self.contentController = contentController
        self.contentView = contentController.view
        self.titleText = title
    }

    public init(contentView: UIView, title: String, overrideTitle: Bool, bottomConstraint: Int = -18) {
        super.init(nibName: nil, bundle: nil)
        self.contentView = contentView
        self.titleText = title
        self.overrideTitle = overrideTitle
        self.bottomConstraint = bottomConstraint
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViews()
        configureView()
        hideKeyboardWhenTappedAround()
        hideTitleStackView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.activateView()
    }
    
    private func setupUI() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView?.translatesAutoresizingMaskIntoConstraints = false

        if cornerRadius > 0 {
            containerView.layer.cornerRadius = cornerRadius
            containerView.layer.masksToBounds = true
        }
    }

    private func setupViews() {
        if let contentController = contentController {
            addChild(contentController)
        }
        addViews()
    }

    private func addViews() {
        view.addSubview(containerView)
        containerView.backgroundColor = .white

        if let contentView = contentView {
            if (overrideTitle == true) {
                containerView.addSubview(contentView)
            } else {
                containerView.addSubview(contentView)
                containerView.addSubview(titleStackView)
            }
            
            if (overrideTitle == true){
                NSLayoutConstraint.activate([

                    containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

                    contentView.topAnchor.constraint(equalTo: containerView.topAnchor),
                    contentView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                    contentView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                    contentView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                ])
            }else{
            NSLayoutConstraint.activate([

                containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

                titleStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
                titleStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: view.frame.width / 6),
                titleStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
                titleStackView.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: CGFloat(bottomConstraint ?? -18)),

                contentView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                contentView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

            ])
            }
        }
    }

    
    private func configureView() {
        titleLabel.text = titleText
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
             if touch?.view == self.view {
                 dismiss(animated: true) {
                    self.delegate?.activateView()
                }
            }
    }

    @objc private func tappedCloseButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    func hideTitleStackView() {
        guard let isStackViewHidden = isStackViewHidden else {
            return
        }
        titleStackView.isHidden = isStackViewHidden
        contentView?.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
    }
}

protocol BottomSheetDelegate {
    func activateView()
}
