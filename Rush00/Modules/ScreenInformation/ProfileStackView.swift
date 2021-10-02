//
//  ProfileStackView.swift
//  SwiftyCompanion
//
//  Created by Маргарита Морозова on 28.05.2021.
//

import UIKit

class ProfileStackView: UIStackView {
    
    lazy var color: UIColor = UIColor()
    
//  MARK: StackViews
    lazy var emailStackView: UIStackView = UIStackView()
    lazy var cityStackView: UIStackView = UIStackView()
    lazy var walletStackView: UIStackView = UIStackView()
    lazy var pointsStackView: UIStackView = UIStackView()
    lazy var gradeStackView: UIStackView = UIStackView()
    lazy var cursusStackView: UIStackView = UIStackView()
    lazy var namesStackView: UIStackView = UIStackView()
    
//    MARK: Cursus
    lazy var cursusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constant.fontSize)
        label.text = "Cursus"
        
        return label
    }()
    
    lazy var cursusSmallButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: Constant.smallFont)
        button.setTitleColor(.black, for: .normal)
        
        return button
    }()
    
//    MARK: Grade
    lazy var gradeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constant.fontSize)
        label.text = "Grade"
        
        return label
    }()
    
    lazy var gradeSmallLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constant.smallFont)
        label.textColor = .black
        
        return label
    }()
    
//    MARK: Wallet
    lazy var walletLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constant.fontSize)
        label.text = "Wallet"
        
        return label
    }()
    
    lazy var walletSmallLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constant.smallFont)
        label.textColor = .black
        
        return label
    }()
    
//    MARK: Points
    lazy var pointsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constant.fontSize)
        label.text = "Evaluation points"
        
        return label
    }()
    
    lazy var pointsSmallLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constant.smallFont)
        label.textColor = .black
        
        return label
    }()
    
//    MARK: Names
    lazy var fullNameLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constant.nameSize, weight: UIFont.Weight.bold)
        
        return label
    }()
    
    lazy var shortNameLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constant.fontSize)
        
        return label
    }()
    
//    MARK: Email
    lazy var emailLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constant.fontSize)
        
        return label
    }()
    
    lazy var emailIconImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "email_ic")
        imageView.widthAnchor.constraint(equalToConstant: Constant.widthHeight).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: Constant.widthHeight).isActive = true
        
        return imageView
    }()
    
//    MARK: City
    lazy var cityLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constant.fontSize)
        
        return label
    }()
    
    lazy var cityIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "city_ic")
        imageView.widthAnchor.constraint(equalToConstant: Constant.widthHeight).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: Constant.widthHeight).isActive = true
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        settingStackView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func settingStackView() {
        fullNameLabel.translatesAutoresizingMaskIntoConstraints = false
        shortNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        emailStackView.spacing = Constant.profileHeaderSpacing
        emailStackView.axis = .horizontal
        emailStackView.addArrangedSubview(emailLabel)
        emailStackView.addArrangedSubview(emailIconImageView)
        emailStackView.translatesAutoresizingMaskIntoConstraints = false
        
        cityStackView.spacing = Constant.profileHeaderSpacing
        cityStackView.axis = .horizontal
        cityStackView.addArrangedSubview(cityLabel)
        cityStackView.addArrangedSubview(cityIconImageView)
        cityStackView.translatesAutoresizingMaskIntoConstraints = false
        
        walletStackView.spacing = Constant.profileHeaderSpacing
        walletStackView.axis = .horizontal
        walletStackView.addArrangedSubview(walletLabel)
        walletStackView.addArrangedSubview(walletSmallLabel)
        walletStackView.translatesAutoresizingMaskIntoConstraints = false
        
        gradeStackView.spacing = Constant.profileHeaderSpacing
        gradeStackView.axis = .horizontal
        gradeStackView.addArrangedSubview(gradeLabel)
        gradeStackView.addArrangedSubview(gradeSmallLabel)
        gradeStackView.translatesAutoresizingMaskIntoConstraints = false
        
        cursusStackView.spacing = Constant.profileHeaderSpacing
        cursusStackView.axis = .horizontal
        cursusStackView.addArrangedSubview(cursusLabel)
        cursusStackView.addArrangedSubview(cursusSmallButton)
        cursusStackView.translatesAutoresizingMaskIntoConstraints = false
        
        namesStackView.spacing = Constant.profileHeaderSpacing
        namesStackView.axis = .horizontal
        namesStackView.addArrangedSubview(fullNameLabel)
        namesStackView.addArrangedSubview(shortNameLabel)
        namesStackView.translatesAutoresizingMaskIntoConstraints = false
        
        pointsStackView.spacing = Constant.profileHeaderSpacing
        pointsStackView.axis = .horizontal
        pointsStackView.addArrangedSubview(pointsLabel)
        pointsStackView.addArrangedSubview(pointsSmallLabel)
        pointsStackView.translatesAutoresizingMaskIntoConstraints = false

        self.spacing = Constant.profileHeaderSpacing
        self.axis = .vertical
        self.alignment = .center
        self.addArrangedSubview(namesStackView)
//        self.addArrangedSubview(shortNameLabel)
        self.addArrangedSubview(walletStackView)
        self.addArrangedSubview(pointsStackView)
        self.addArrangedSubview(cursusStackView)
        self.addArrangedSubview(gradeStackView)
        self.addArrangedSubview(emailStackView)
        self.addArrangedSubview(cityStackView)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func settingValue(fullName: String,
                      shortName: String,
                      email: String,
                      city: String,
                      wallet: Int,
                      points: Int,
                      grade: String,
                      cursus: String,
                      color: UIColor) {
        fullNameLabel.text = fullName
        shortNameLabel.text = shortName
        emailLabel.text = email
        cityLabel.text = city
        walletSmallLabel.text = String(wallet) + " \u{20B3}"
        pointsSmallLabel.text = String(points)
        gradeSmallLabel.text = grade
        cursusSmallButton.setTitle(NSLocalizedString(cursus, comment: ""), for: .normal)
        walletLabel.textColor = color
        pointsLabel.textColor = color
        cursusLabel.textColor = color
        gradeLabel.textColor = color
        fullNameLabel.textColor = color
    }
}

extension ProfileStackView {
    struct Constant {
        static let profileHeaderSpacing = CGFloat(10)
        static let nameSize = CGFloat(20)
        static let fontSize = CGFloat(15)
        static let smallFont = CGFloat(13)
        static let widthHeight = CGFloat(20)
    }
}
