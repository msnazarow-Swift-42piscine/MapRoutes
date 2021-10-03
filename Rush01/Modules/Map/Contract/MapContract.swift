//
//  MapContract.swift
//  Rush01
//
//  Created by out-nazarov2-ms on 03.10.2021.
//  
//

import UIKit
import GoogleMaps

// MARK: View Output (Presenter -> View)
protocol PresenterToViewMapProtocol: AnyObject {
    func clearFrom()
    func clearTo()
    func myLocationFrom()
    func myLocationTo()
    func swapToFrom()
    func openAutocomplete(with location: toFromLocation)
    func addPolyline(with path: GMSPath)
    func showAlert()
    func hideMarker(_ marker: GMSMarker)
    func addMarkerAt(_ location: CLLocationCoordinate2D)
}


// MARK: View Input (View -> Presenter)
protocol ViewToPresenterMapProtocol: AnyObject {
    var dataSource:PresenterToDataSourceMapProtocol { get }
    var fromMarkerLocation: CLLocationCoordinate2D! { get set}
    var toMarkerLocation: CLLocationCoordinate2D!  { get set}

    func viewDidLoad()
    func buttonDidTapped(with tag: ButtonTag!)
    func editingDidBegin(with tag: TextFieldTag!)
    func textFieldShouldClear(with tag: TextFieldTag!)
    func didTapMarker(_ marker: GMSMarker)
    func didLongPressAt(_ coordinate: CLLocationCoordinate2D)
}


// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorMapProtocol: AnyObject {
    func getRoute(from fromLocation: CLLocationCoordinate2D, to toLocation: CLLocationCoordinate2D, complition: @escaping (Result<GMSPath, Error>) -> Void)
}

// MARK: Presenter Output (Presenter -> Router)
protocol PresenterToRouterMapProtocol: AnyObject {
    
}

// MARK: Presenter Output (Presenter -> DataSource)
protocol PresenterToDataSourceMapProtocol: UITableViewDataSource {
    func updateForSections(_ sections: [SectionModel])
}

// MARK: Cell Input (Cell -> Presenter)
protocol CellToPresenterMapProtocol: AnyObject {

}
