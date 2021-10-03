//
//  MapAssembly.swift
//  Rush01
//
//  Created by out-nazarov2-ms on 03.10.2021.
//  
//

import UIKit

enum MapAssembly{
    
    // MARK: Static methods
    static func createModule() -> UIViewController {

        let viewController = MapViewController()
        let router = MapRouter(view: viewController)
        let interactor = MapInteractor()
        let dataSource = MapPresenterDataSource()
        let presenter = MapPresenter(view: viewController, interactor: interactor, router: router, dataSource: dataSource)

        viewController.presenter = presenter
        dataSource.presenter = presenter

        return viewController
    }
}
