//
//  SkillView.swift
//  SwiftyCompanion
//
//  Created by Маргарита Морозова on 12.08.2021.
//

import UIKit

class SkillView: UIView {

    lazy var skillNames: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .black
        
        return label
    }()
    
    lazy var skillScore: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .black
        
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        settingConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func settingView(name: String,
                     score: Double,
                     color: UIColor) {
        skillScore.textColor = .black
        skillScore.text = String(format: "%.02f ", score)
        skillNames.text = String(name)
        skillNames.textColor = color
    }
    
    func settingConstraints() {
        self.addSubview(skillNames)
        self.addSubview(skillScore)
        skillScore.translatesAutoresizingMaskIntoConstraints = false
        skillNames.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            
            skillNames.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                constant: Constant.leadingTrailingAnchor),
            skillNames.topAnchor.constraint(equalTo: topAnchor,
                                            constant: Constant.topBottomAnchor),
            skillNames.bottomAnchor.constraint(equalTo: bottomAnchor,
                                               constant: -Constant.topBottomAnchor),
            
            skillScore.topAnchor.constraint(equalTo: topAnchor,
                                            constant: Constant.topBottomAnchor),
            skillScore.bottomAnchor.constraint(equalTo: bottomAnchor,
                                               constant: -Constant.topBottomAnchor),
            skillScore.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                 constant: -Constant.leadingTrailingAnchor),
            skillScore.leadingAnchor.constraint(greaterThanOrEqualTo: skillNames.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        self.addConstraints(constraints)
    }
}

extension SkillView {
    struct Constant {
        static let leadingTrailingAnchor = CGFloat(10)
        static let topBottomAnchor = CGFloat(5)
    }
}
