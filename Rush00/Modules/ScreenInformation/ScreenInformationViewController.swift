//
//  ScreenInformationViewController.swift
//  SwiftyCompanion
//
//  Created by Маргарита Морозова on 08.05.2021.
//

import UIKit

class ScreenInformationViewController: UIViewController {

    var viewModel: ScreenInformationViewModel!
    // MARK: Объявление переменных
    lazy var scrollView: UIScrollView = UIScrollView()
    
    let scrollViewContainer: UIStackView = {
        let view = UIStackView()

        view.axis = .vertical
        view.spacing = Const.spacingScrollView
        view.alignment = .center

        return view
    }()
    
    lazy var segmentControlView = SegmentControlView()
    
    lazy var avatarImageView: UIImageView = UIImageView()
    
    lazy var profileInformationStackView: ProfileStackView = ProfileStackView()
    
    lazy var coalitionView: CoalitionView = CoalitionView()
    
    lazy var locationStackView: UIStackView = UIStackView()
    lazy var activeLabel = UILabel()
    lazy var locationLabel = UILabel()
    
    lazy var coalitionColor: UIColor = .orange
    lazy var coalitionName: String = "Without a coalition"
    
    // MARK: Level
    lazy var levelBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = Const.cornerRadius
        
        return view
    }()
    lazy var levelView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Const.cornerRadius
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        
        return view
    }()
    lazy var levelLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: Const.smallFont)
        
        return label
    }()
    lazy var selectedCursus: Int = -1
    
    lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Marks", "Skills"])
        segmentedControl.addTarget(self, action: #selector(segmentAction(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        
        return segmentedControl
    }()
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        settingConstraints()
        settingData()
    }

    //MARK: Segment action
    @objc func segmentAction(_ segmentedControl: UISegmentedControl) {
        switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            segmentControlView.settingView(projectsUser: viewModel.userInformation.projectsUser, skillsUser: viewModel.userInformation.userCourse[selectedCursus].skills, color: coalitionColor, id: .project)
            break
        case 1:
            segmentControlView.settingView(projectsUser: viewModel.userInformation.projectsUser, skillsUser: viewModel.userInformation.userCourse[selectedCursus].skills, color: coalitionColor, id: .skill)
            break
        default:
            segmentControlView.settingView(projectsUser: viewModel.userInformation.projectsUser, skillsUser: viewModel.userInformation.userCourse[selectedCursus].skills, color: coalitionColor, id: .project)
            break
        }
    }
    
//    MARK: Setting Data
    func settingData() {
        let userInfo = viewModel.userInformation
        if viewModel.coalitionInformation.count != 0 {
            coalitionColor = viewModel.coalitionInformation[0].color ?? .orange
            coalitionName = viewModel.coalitionInformation[0].name
        }
        if userInfo.location == "" {
            activeLabel.text = "Unavailiable"
            locationLabel.text = "-"
        } else {
            activeLabel.text = "Availiable"
            locationLabel.text = userInfo.location
        }
        levelView.backgroundColor = coalitionColor
        segmentedControl.backgroundColor = coalitionColor
        if selectedCursus == -1 {
            selectedCursus = userInfo.userCourse.count - 1
        }
        segmentControlView.settingView(projectsUser: userInfo.projectsUser, skillsUser: userInfo.userCourse[selectedCursus].skills, color: coalitionColor, id: .project)
        guard let userCourse = userInfo.userCourse[selectedCursus].cursus?.name else { return }
        profileInformationStackView.settingValue(fullName: userInfo.fullName,
                                                 shortName: userInfo.login,
                                                 email: userInfo.email,
                                                 city: userInfo.campus[0].name,
                                                 wallet: userInfo.wallet,
                                                 points: userInfo.correctionPoint,
                                                 grade: userInfo.userCourse[selectedCursus].grade,
                                                 cursus: userCourse,
                                                 color: coalitionColor)
        coalitionView.settingValue(color: coalitionColor,
                                          names: coalitionName)
        
        let imageURL = URL(string: userInfo.imageUrl)
        var imageData: NSData?
        if let imageURL = imageURL {
            imageData = NSData(contentsOf: imageURL)
        } else { return }
        if let imageData = imageData {
            avatarImageView.image = UIImage(data: imageData as Data)
        } else { avatarImageView.image = UIImage(named: "profile_ic")}

        let level = Int(userInfo.userCourse[selectedCursus].level)
        let percent = (Double(userInfo.userCourse[selectedCursus].level)).truncatingRemainder(dividingBy: 1)
        let width = view.frame.width - Const.leadingAnchorCoalition + Const.trailingAnchorCoalition
        let widthLevel = Int(Double(width) * (userInfo.userCourse[selectedCursus].level - Double(level)))
        levelView.widthAnchor.constraint(equalToConstant: CGFloat(widthLevel)).isActive = true
        levelLabel.text = "level \(Int(level)) - \(Int(percent * 100))%"
    }
    
    //MARK: Add subviews
    func settingView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        levelBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        levelView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        locationStackView.translatesAutoresizingMaskIntoConstraints = false
        scrollViewContainer.translatesAutoresizingMaskIntoConstraints = false
        segmentControlView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(scrollViewContainer)
        scrollViewContainer.addArrangedSubview(avatarImageView)
        scrollViewContainer.addArrangedSubview(coalitionView)
        scrollViewContainer.addArrangedSubview(profileInformationStackView)
        scrollViewContainer.addArrangedSubview(locationStackView)
        scrollViewContainer.addArrangedSubview(levelBackgroundView)
        scrollViewContainer.addArrangedSubview(segmentedControl)
        scrollViewContainer.addArrangedSubview(segmentControlView)
        
        locationStackView.spacing = Const.profileHeaderSpacing
        locationStackView.axis = .vertical
        locationStackView.alignment = .center
        locationStackView.addArrangedSubview(activeLabel)
        locationStackView.addArrangedSubview(locationLabel)
        levelBackgroundView.addSubview(levelView)
        levelView.addSubview(levelLabel)
    }
    
    //MARK: Constraints
    func settingConstraints() {
        settingView()
        let constraintsView = [
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ]
        let constraintsScrollView = [
            scrollViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            avatarImageView.widthAnchor.constraint(equalToConstant: view.frame.width),
            avatarImageView.heightAnchor.constraint(equalToConstant: view.frame.width),
            avatarImageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            
            locationStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            locationStackView.topAnchor.constraint(equalTo: profileInformationStackView.bottomAnchor,
                                                   constant: Const.bottomAnchorLocation),
            
            profileInformationStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            profileInformationStackView.topAnchor.constraint(equalTo: coalitionView.bottomAnchor, constant: Const.topAnchorAvatar),
            
            coalitionView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            coalitionView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: Const.topAnchorCoalition),
            
            levelBackgroundView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: Const.leadingAnchorCoalition),
            levelBackgroundView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: Const.trailingAnchorCoalition),
            levelBackgroundView.topAnchor.constraint(equalTo: locationStackView.bottomAnchor,
                                                     constant: Const.topAnchorLevelBackView),
            levelBackgroundView.heightAnchor.constraint(equalToConstant: Const.heightAnchorLevelBackView),

            levelView.topAnchor.constraint(equalTo: levelBackgroundView.topAnchor),
            levelView.bottomAnchor.constraint(equalTo: levelBackgroundView.bottomAnchor),
            levelView.leadingAnchor.constraint(equalTo: levelBackgroundView.leadingAnchor),
            
            levelLabel.topAnchor.constraint(equalTo: levelBackgroundView.topAnchor),
            levelLabel.bottomAnchor.constraint(equalTo: levelBackgroundView.bottomAnchor),
            levelLabel.centerXAnchor.constraint(equalTo: levelBackgroundView.centerXAnchor),
            
            segmentedControl.topAnchor.constraint(equalTo: levelBackgroundView.bottomAnchor,
                                                  constant: Const.topAnchorControl),
            segmentedControl.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor,
                                                      constant: Const.leadingAnchorControl),
            segmentedControl.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor,
                                                       constant: Const.trailingAnchorControl),
            segmentedControl.heightAnchor.constraint(equalToConstant: Const.heightAnchorControl),
            
            segmentControlView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            segmentControlView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor,
                                                        constant: Const.leadingAnchorControlView),
            segmentControlView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor,
                                                         constant: Const.trailingAnchorControlView),
            segmentControlView.heightAnchor.constraint(equalToConstant: Const.heightAnchorControlView)
        ]
        NSLayoutConstraint.activate(constraintsScrollView)
        NSLayoutConstraint.activate(constraintsView)
        view.addConstraints(constraintsView)
        scrollView.addConstraints(constraintsScrollView)
    }
}

extension ScreenInformationViewController {
    fileprivate struct Const {
        static let spacingScrollView = CGFloat(10)
        static let cornerRadius = CGFloat(5)
        static let smallFont = CGFloat(13)
        static let profileHeaderSpacing = CGFloat(10)
        static let topAnchorAvatar = CGFloat(20)
        
        static let topAnchorCoalition = CGFloat(30)
        static let leadingAnchorCoalition = CGFloat(30)
        static let trailingAnchorCoalition = CGFloat(-25)
        
        static let leadingAnchorControlView = CGFloat(30)
        static let trailingAnchorControlView = CGFloat(-26)
        static let heightAnchorControlView = CGFloat(500)
        
        static let topAnchorControl = CGFloat(40)
        static let leadingAnchorControl = CGFloat(30)
        static let trailingAnchorControl = CGFloat(-26)
        static let heightAnchorControl = CGFloat(30)
        
        static let bottomAnchorLocation = CGFloat(40)
        static let topAnchorLevelBackView = CGFloat(40)
        static let heightAnchorLevelBackView = CGFloat(20)
    }
}
