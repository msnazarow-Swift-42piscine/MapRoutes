//
//  ScreenInformationViewModel.swift
//  SwiftyCompanion
//
//  Created by Маргарита Морозова on 11.08.2021.
//

import UIKit

protocol ScreenInformationViewModelProtocol {
    var userInformation: UserInformationModel { get }
    var coalitionInformation: [CoalitionModel] { get }
}

class ScreenInformationViewModel: ScreenInformationViewModelProtocol {
    var userInformation: UserInformationModel
    var coalitionInformation: [CoalitionModel]
    
    init(userInformation: UserInformationModel, coalitionInformation: [CoalitionModel]) {
        self.userInformation = userInformation
        self.coalitionInformation = coalitionInformation
    }
}
