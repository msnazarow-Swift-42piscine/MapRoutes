//
//  MapPresenter.swift
//  Rush01
//
//  Created by out-nazarov2-ms on 03.10.2021.
//  
//

import Foundation
import CoreLocation
import GoogleMaps

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

    var fromMarkerLocation: CLLocationCoordinate2D!
    var toMarkerLocation: CLLocationCoordinate2D!

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
            getRoute()
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

    private func getRoute(){
        if fromMarkerLocation != nil && toMarkerLocation != nil {
            interactor.getRoute(from: fromMarkerLocation, to: toMarkerLocation) { result in
                switch result {
                case .success(let path):
                    self.view.addPolyline(with: path)
                case .failure:
                    self.view.showAlert()
                }
            }
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

    func didTapMarker(_ marker: GMSMarker) {
        if marker.position == fromMarkerLocation {
            fromMarkerLocation = nil
        } else if marker.position == toMarkerLocation {
            toMarkerLocation = nil
        }
        view.hideMarker(marker)
    }

    func didLongPressAt(_ coordinate: CLLocationCoordinate2D) {
        if fromMarkerLocation == nil {
            fromMarkerLocation = coordinate
        } else {
            toMarkerLocation = coordinate
        }
        view.addMarkerAt(coordinate)
    }
}

extension MapPresenter: CellToPresenterMapProtocol {
    
}
