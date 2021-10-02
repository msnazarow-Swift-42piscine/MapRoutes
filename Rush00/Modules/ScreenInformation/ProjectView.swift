//
//  ProjectView.swift
//  SwiftyCompanion
//
//  Created by Маргарита Морозова on 12.08.2021.
//

import UIKit

class ProjectView: UIView {

    lazy var projectNames: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: Constant.fontSize)
        label.textColor = .black
        
        return label
    }()
    
    lazy var projectScore: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: Constant.fontSize)
        label.textColor = .black
        
        return label
    }()
    
    lazy var imageStatus: UIImageView = {
        let image = UIImageView()
        image.tintColor = .gray
        image.image = UIImage(systemName: "clock")
        
        return image
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
                     status: String,
                     score: Int,
                     color: UIColor,
                     isValidated: Bool) {
        if isValidated {
            projectScore.textColor = .systemGreen
        } else {
            projectScore.textColor = .red
        }
        if status == "in_progress" {
            imageStatus.isHidden = false
            projectScore.isHidden = true
        } else {
            imageStatus.isHidden = true
            projectScore.isHidden = false
            projectScore.text = String(score)
        }
        projectNames.text = String(name)
        projectNames.textColor = color
    }
    
    func settingConstraints() {
        self.addSubview(projectNames)
        self.addSubview(projectScore)
        self.addSubview(imageStatus)
        projectNames.translatesAutoresizingMaskIntoConstraints = false
        projectScore.translatesAutoresizingMaskIntoConstraints = false
        imageStatus.translatesAutoresizingMaskIntoConstraints = false
        imageStatus.isHidden = true
        let constraints = [
            
            projectNames.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                  constant: Constant.leadingTrailingAnchor),
            projectNames.topAnchor.constraint(equalTo: topAnchor,
                                              constant: Constant.topBottomAnchor),
            projectNames.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                   constant: -5),
            
            projectScore.topAnchor.constraint(equalTo: topAnchor,
                                              constant: Constant.topBottomAnchor),
            projectScore.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                 constant: -Constant.topBottomAnchor),
            projectScore.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                   constant: -Constant.leadingTrailingAnchor),
            projectScore.leadingAnchor.constraint(greaterThanOrEqualTo: projectNames.trailingAnchor),
            
            imageStatus.topAnchor.constraint(equalTo: topAnchor,
                                             constant: Constant.topBottomAnchor),
            imageStatus.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                constant: -Constant.topBottomAnchor),
            imageStatus.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                  constant: -Constant.leadingTrailingAnchor),
            imageStatus.leadingAnchor.constraint(greaterThanOrEqualTo: projectNames.trailingAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
        self.addConstraints(constraints)
    }
}

extension ProjectView {
    struct Constant {
        static let fontSize = CGFloat(15)
        static let leadingTrailingAnchor = CGFloat(10)
        static let topBottomAnchor = CGFloat(5)
    }
}
