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
import GooglePlaces

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
    var selectedLocation: ToFromLocation = .from

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
            guard let myLocation = view.getMyLocation() else { break }
            if toMarkerLocation == myLocation {
                view.setTextFieldText(with: .to, "")
                view.hideMarker(title: "To")
                toMarkerLocation = nil
            }
            view.setTextFieldText(with: .from, .myLocation)
            view.addMarker(title: .from, at: myLocation)
            fromMarkerLocation = myLocation
            view.zoom(to: myLocation)
            view.clearRoute()
        case .mylocationTo:
            guard let myLocation = view.getMyLocation() else { break }
            if fromMarkerLocation == myLocation {
                view.setTextFieldText(with: .from, "")
                view.hideMarker(title: "From")
                fromMarkerLocation = nil
            }
            view.setTextFieldText(with: .to, .myLocation)
            view.addMarker(title: .to, at: myLocation)
            toMarkerLocation = myLocation
            view.zoom(to: myLocation)
            view.clearRoute()
        case .clearFrom:
            view.setTextFieldText(with: .from, "")
        case .clearTo:
            view.setTextFieldText(with: .to, "")
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
                    self.view.addRoute(with: path)
                case .failure:
                    self.view.showAlert()
                }
            }
        }
    }

    func textFieldShouldClear(with tag: TextFieldTag!) {
        view.setTextFieldText(with: tag, "")
        view.clearRoute()
        switch tag {
        case .from:
            view.hideMarker(title: .from)
            fromMarkerLocation = nil
        case .to:
            view.hideMarker(title: .to)
            toMarkerLocation = nil
        default:
            break
        }
    }

    func editingDidBegin(with tag: TextFieldTag!) {
        switch tag {
        case .from:
            selectedLocation = .from
            view.openAutocomplete(with: .from)
        case .to:
            selectedLocation = .to
            view.openAutocomplete(with: .to)
        default:
            break
        }
    }

    func didTapMarker(title: String) {
        view.hideMarker(title: title)
        switch title {
        case .from:
            fromMarkerLocation = nil
        case .to:
            toMarkerLocation = nil
        default: break
        }
        view.clearRoute()
    }

    func didLongPressAt(_ coordinate: CLLocationCoordinate2D) {
        if fromMarkerLocation == nil {
            fromMarkerLocation = coordinate
            view.addMarker(title: "From" , at: fromMarkerLocation)
            view.setTextFieldText(with: .from, "\(coordinate.latitude) \(coordinate.latitude)")
        } else {
            toMarkerLocation = coordinate
            view.addMarker(title: "To" , at: toMarkerLocation)
            view.setTextFieldText(with: .to, "\(coordinate.latitude) \(coordinate.latitude)")
        }
        view.clearRoute()
    }

    func didAutocompleteWith(place: GMSPlace) {
        switch selectedLocation {
        case .from:
            if let address = place.formattedAddress {
                view.setTextFieldText(with: .from, address)
            }
            fromMarkerLocation = place.coordinate
            view.addMarker(title: .from, at: place.coordinate)
        case .to:
            if let address = place.formattedAddress {
                view.setTextFieldText(with: .to, address)
            }
            toMarkerLocation = place.coordinate
            view.addMarker(title: .to, at: place.coordinate)
        }
        view.zoom(to: place.coordinate)
//        self.dismiss(animated: true, completion: nil)
    }
}

extension MapPresenter: CellToPresenterMapProtocol {
    
}
