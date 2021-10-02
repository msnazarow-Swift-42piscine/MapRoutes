//
//  ScreenInformationAssembly.swift
//  SwiftyCompanion
//
//  Created by Маргарита Морозова on 11.08.2021.
//

import UIKit

class ScreenInformationAssembly {
    static func screenInformationViewController(userInformation: UserInformationModel,
                                                coalitionInformation: [CoalitionModel]) -> UIViewController{
        let viewModel = ScreenInformationViewModel(userInformation: userInformation, coalitionInformation: coalitionInformation)
        let viewController = ScreenInformationViewController()
        viewController.viewModel = viewModel
        return viewController
    }
}
