//
//  MapPresenter.swift
//  Rush01
//
//  Created by out-nazarov2-ms on 03.10.2021.
//  
//

import Foundation

enum ButtonTag: Int {
    case getRoute = 0
    case swapToFrom = 1
    case mylocationFrom = 2
    case mylocationTo = 3
    case clearFrom = 4
    case clearTo = 5
}

enum TextFieldTag: Int {
    case from
    case to
}
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

    func buttonDidTapped(with tag: ButtonTag!) {
        switch tag {
        case .getRoute:
            view.getRoute()
        case .mylocationFrom:
            view.myLocationFrom()
        case .mylocationTo:
            view.myLocationTo()
        case .clearFrom:
            view.clearFrom()
        case .clearTo:
            view.clearTo()
        case .swapToFrom:
            view.swapToFrom()
        default:
            break
        }
    }

    func textFieldShouldClear(with tag: TextFieldTag!) {
        switch tag {
        case .from:
            view.clearFrom()
        case .to:
            view.clearTo()
        default:
            break
        }
    }

    func editingDidBegin(with tag: TextFieldTag!) {
        switch tag {
        case .from:
            view.openAutocomplete(with: .fromLocation)
        case .to:
            view.openAutocomplete(with: .toLocation)
        default:
            break
        }
    }
}

extension MapPresenter: CellToPresenterMapProtocol {
    
}
