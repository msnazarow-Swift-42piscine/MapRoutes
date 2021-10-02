//
//  SegmentControlView.swift
//  SwiftyCompanion
//
//  Created by Маргарита Морозова on 12.08.2021.
//

import UIKit

class SegmentControlView: UIView {
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    let scrollViewContainer: UIStackView = {
        let view = UIStackView()

        view.axis = .vertical
        view.spacing = 10

        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        settingConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func settingView(projectsUser: [ProjectsUserModel],
                     skillsUser: [SkillsModel],
                     color: UIColor,
                     id: ProjOrSkill) {
        for view in scrollViewContainer.subviews {
            view.removeFromSuperview()
        }
        if id == .project {
            for project in projectsUser {
                let view = ProjectView()
                let name = project.project == nil ? "" : project.project!.name
                view.settingView(name: name,
                                 status: project.status,
                                 score: project.finalMark,
                                 color: color,
                                 isValidated: project.isValidated)
                scrollViewContainer.addArrangedSubview(view)
            }
        } else {
            for skill in skillsUser {
                let view = SkillView()
                view.settingView(name: skill.name, score: skill.level, color: color)
                scrollViewContainer.addArrangedSubview(view)
            }
        }
    }
    
    func settingConstraints() {
        self.addSubview(scrollView)
        scrollView.addSubview(scrollViewContainer)
        let constraints = [
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            scrollViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        self.addConstraints(constraints)
    }
}
