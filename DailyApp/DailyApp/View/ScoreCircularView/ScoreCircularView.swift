//
//  ScoreCircularView.swift
//  DailyApp
//
//  Created by Burak Emre gündeş on 20.12.2022.
//

import UIKit

class ScoreCircularView: UIView {

    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()

    private var startPoint = CGFloat(-Double.pi / 2)
      private var endPoint = CGFloat(3 * Double.pi / 2)
    var radius = 40.0

    override func layoutSubviews() {
        super.layoutSubviews()
        frame = bounds
       configure()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()

    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    private lazy var progressStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [progressImageView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 2
        return stackView
    }()


    private lazy var progressImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    func configure(){
        createCircularPath()
        addSubview(progressStackView)

       let progressStackViewConstraints = [
        progressStackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
        progressStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
        progressStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
        progressStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15)
        ]

        NSLayoutConstraint.activate(progressStackViewConstraints)
        progressStackView.layer.zPosition = -1

    }

    func createCircularPath() {
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.width/2, y: frame.height/2), radius: radius, startAngle: startPoint, endAngle: endPoint, clockwise: true)
            circleLayer.path = circularPath.cgPath
            circleLayer.fillColor = UIColor.clear.cgColor
            circleLayer.lineCap = .round
            circleLayer.lineWidth = 8.0
            circleLayer.strokeEnd = 1.0
        circleLayer.strokeColor = UIColor(red: 204.0 / 255.0, green: 204.0 / 255.0, blue: 204.0 / 255.0, alpha: 1.0).cgColor
            layer.addSublayer(circleLayer)
            progressLayer.path = circularPath.cgPath
            progressLayer.fillColor = UIColor.clear.cgColor
            progressLayer.lineCap = .round
            progressLayer.lineWidth = 8.0
            progressLayer.strokeColor = UIColor.crystalBlue.cgColor
            layer.addSublayer(progressLayer)
 }

    func setProgress(value:Double) {
            progressLayer.strokeEnd = CGFloat(value)
    }

    func configureView(progressInfoNumber: Double, progressImage: String,endNode : Bool) {
        if endNode {
           // setImg(image: progressImageView, imgLink: progressImage)
            setProgress(value: 1)
        }else {
            progressImageView.image = UIImage(named: progressImage)
            setProgress(value:progressInfoNumber)
        }

    }
}
