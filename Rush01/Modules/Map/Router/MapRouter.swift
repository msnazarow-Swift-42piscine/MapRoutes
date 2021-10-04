//
//  MapRouter.swift
//  Rush01
//
//  Created by out-nazarov2-ms on 03.10.2021.
//  
//

import UIKit
import GooglePlaces

class MapRouter: PresenterToRouterMapProtocol {
    typealias AutoCompleteViewController = UIViewController & GMSAutocompleteViewControllerDelegate

    // MARK: - Properties
    weak var view: AutoCompleteViewController!

    // MARK: - Init
    init(view: AutoCompleteViewController) {
        self.view = view
    }

    func openAutocomplete(with location: ToFromLocation) {
        let autoCompleteViewController = GMSAutocompleteViewController()
        autoCompleteViewController.delegate = view
        view.present(autoCompleteViewController, animated: true, completion: nil)
    }
    
}
