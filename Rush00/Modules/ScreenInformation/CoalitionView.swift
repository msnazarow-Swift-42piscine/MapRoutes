//
//  CoalitionView.swift
//  SwiftyCompanion
//
//  Created by Маргарита Морозова on 13.08.2021.
//

import UIKit

class CoalitionView: UIView {
    
    lazy var coalitionNames: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: Constant.fontSize)
        label.textColor = .white
        label.text = "Wallet"
        
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        settingConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func settingView() {
        self.layer.cornerRadius = Constant.cornerRadius
        
        coalitionNames.translatesAutoresizingMaskIntoConstraints = false
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(coalitionNames)
    }
    
    func settingValue(color: UIColor,
                      names: String) {
        self.backgroundColor = color
        coalitionNames.text = names
    }
    
    func settingConstraints() {
        settingView()
        let constraints = [
            
            coalitionNames.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                    constant: Constant.leadingAnchor),
            coalitionNames.topAnchor.constraint(equalTo: topAnchor,
                                                constant: Constant.aroundAnchors),
            coalitionNames.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                   constant: -Constant.aroundAnchors),
            coalitionNames.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                     constant: -Constant.leadingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        self.addConstraints(constraints)
    }
}

extension CoalitionView {
    struct Constant {
        static let aroundAnchors = CGFloat(5)
        static let leadingAnchor = CGFloat(10)
        static let fontSize = CGFloat(15)
        static let cornerRadius = CGFloat(5)
    }
}
