//
//  MapPresenter.swift
//  Rush01
//
//  Created by out-nazarov2-ms on 03.10.2021.
//  
//

import Foundation

class MapPresenter: ViewToPresenterMapProtocol {

    // MARK: Properties
    weak var view: PresenterToViewMapProtocol!
    let interactor: PresenterToInteractorMapProtocol
    let router: PresenterToRouterMapProtocol
    let dataSource:PresenterToDataSourceMapProtocol

    // MARK: Init
    init(view: PresenterToViewMapProtocol,
         interactor: PresenterToInteractorMapProtocol,
         router: PresenterToRouterMapProtocol,
         dataSource: PresenterToDataSourceMapProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.dataSource = dataSource
    }

    func viewDidLoad(){

    }
}

extension MapPresenter: CellToPresenterMapProtocol {
    
}
