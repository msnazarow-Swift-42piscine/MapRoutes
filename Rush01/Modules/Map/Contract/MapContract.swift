//
//  MapContract.swift
//  Rush01
//
//  Created by out-nazarov2-ms on 03.10.2021.
//  
//

import UIKit
import GoogleMaps
import GooglePlaces

// MARK: View Output (Presenter -> View)
protocol PresenterToViewMapProtocol: AnyObject {
    func swapToFrom()
    func showAlert()
    func setTextFieldText(with tag: TextFieldTag, _ text: String)
    func addMarker(title: String, at location: CLLocationCoordinate2D)
    func removeMarker(title: String)
    func addRoute(with path: GMSPath)
    func removeRoute()
    func zoom(to location: CLLocationCoordinate2D)
    func getMyLocation() -> CLLocationCoordinate2D?
}


// MARK: View Input (View -> Presenter)
protocol ViewToPresenterMapProtocol: AnyObject {
    var dataSource:PresenterToDataSourceMapProtocol { get }
//    var fromMarkerLocation: CLLocationCoordinate2D! { get set}
//    var toMarkerLocation: CLLocationCoordinate2D!  { get set}

    func viewDidLoad()
    func buttonDidTapped(with tag: ButtonTag!)
    func editingDidBegin(with tag: TextFieldTag!)
    func textFieldShouldClear(with tag: TextFieldTag!)
    func didTapMarker(title: String)
    func didLongPressAt(_ coordinate: CLLocationCoordinate2D)
    func didAutocompleteWith(place: GMSPlace)
    func switcherChanges(_ walk: Bool)
}


// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorMapProtocol: AnyObject {
    func getRoute(from fromLocation: CLLocationCoordinate2D, to toLocation: CLLocationCoordinate2D, walk: Bool, complition: @escaping (Result<GMSPath, Error>) -> Void)
}

// MARK: Presenter Output (Presenter -> Router)
protocol PresenterToRouterMapProtocol: AnyObject {
    func openAutocomplete(with location: ToFromLocation)
}

// MARK: Presenter Output (Presenter -> DataSource)
protocol PresenterToDataSourceMapProtocol: UITableViewDataSource {
    func updateForSections(_ sections: [SectionModel])
}

// MARK: Cell Input (Cell -> Presenter)
protocol CellToPresenterMapProtocol: AnyObject {

}
