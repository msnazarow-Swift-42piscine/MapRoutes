//
//  MapViewController.swift
//  Rush01
//
//  Created by Маргарита Морозова on 02.10.2021.
//  Updated by out-nazarov2-ms on 03.10.2021.
//

import Alamofire
import GoogleMaps
import GooglePlaces
import SwiftyJSON
import UIKit

class MapViewController: UIViewController {

    // MARK: - Properties
    var presenter: ViewToPresenterMapProtocol!

    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var toTextField: UITextField!
//    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var getRouteButton: UIButton!

    var fromLocation = CLLocationCoordinate2D()
    var toLocation = CLLocationCoordinate2D()
    var currentLocation: CLLocationCoordinate2D?
    var selectedLocation = toFromLocation.fromLocation

    let fromMarker: GMSMarker = {
        let marker = GMSMarker()
        marker.opacity = 0
        return marker
    }()

    let toMarker: GMSMarker = {
        let marker = GMSMarker()
        marker.opacity = 0
        return marker
    }()

    lazy var googleMapView: GMSMapView = {
        let mapView = GMSMapView.map(withFrame: CGRect(), camera: camera)
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.delegate = self
        return mapView
    }()

    // camera это положение куда смотрит камера на карте, чем больше zoom, тем ближе
    // начальное положение камеры - школа в Москве
    lazy var camera: GMSCameraPosition = {
        let camera = GMSCameraPosition.camera(withLatitude: 55.797, longitude: 37.580, zoom: 15.0)
        return camera
    }()

    var polyline = GMSPolyline()

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }

//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        //совмещение фрэйма гугловской карты и вьюхи в сториборде
//        super.viewWillTransition(to: size, with: coordinator)
//        googleMapView.frame = mapView.frame
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//    }
    private func setupUI() {
        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
//        mapView.addSubview(googleMapView)
        view.addSubview(googleMapView)
//        view.sendSubviewToBack(mapView)
    }

    private func setupConstraints(){
        NSLayoutConstraint.activate([
            googleMapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            googleMapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            googleMapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            googleMapView.bottomAnchor.constraint(equalTo: getRouteButton.topAnchor,constant: -5)
        ])
    }

    @IBAction func buttonDidTapped(_ sender: UIButton) {
        presenter.buttonDidTapped(with: ButtonTag(rawValue: sender.tag))
    }

    @IBAction func editingDidBegin(_ sender: UITextField) {
        presenter.editingDidBegin(with: TextFieldTag(rawValue: sender.tag))
    }
}

extension MapViewController: PresenterToViewMapProtocol{

    // Очистка позиции from
    func clearFrom(){
        fromTextField.text = ""
        polyline.map = nil
        fromMarker.opacity = 0
    }

    // Очистка позиции to
    func clearTo(){
        toTextField.text = ""
        polyline.map = nil
        toMarker.opacity = 0
    }

    // Установка моей геопозиции в From
    func myLocationFrom(){
        let myLocation = googleMapView.myLocation!.coordinate
        if  toTextField.text == "My location" {
            toTextField.text = ""
            toMarker.opacity = 0
        }
        fromTextField.text = "My location"
        fromLocation = myLocation
        fromMarker.position = myLocation
        fromMarker.opacity = 1
        fromMarker.map = googleMapView
        googleMapView.animate(to: GMSCameraPosition.camera(withTarget: myLocation, zoom: 15.0))
    }

    // Установка моей геопозиции в To
    func myLocationTo() {
        let myLocation = googleMapView.myLocation!.coordinate
        if  fromTextField.text == "My location" {
            fromTextField.text = ""
            fromMarker.opacity = 0
        }
        toTextField.text = "My location"
        toLocation = myLocation
        toMarker.position = myLocation
        toMarker.opacity = 1
        toMarker.map = googleMapView
        googleMapView.animate(to: GMSCameraPosition.camera(withTarget: myLocation, zoom: 15.0))
    }

//    Меняю from и to местами
    func swapToFrom() {
        let newLocation = fromLocation
        fromLocation = toLocation
        fromMarker.position = toLocation
        toLocation = newLocation
        toMarker.position = newLocation
        let newTextLocation = fromTextField.text
        fromTextField.text = toTextField.text
        toTextField.text = newTextLocation
    }


    func openAutocomplete(with location: toFromLocation) {
        let autoCompleteViewController = GMSAutocompleteViewController()
        autoCompleteViewController.delegate = self
        selectedLocation = location
        self.present(autoCompleteViewController, animated: true, completion: nil)
    }

     func getRoute() {
        if fromMarker.opacity == 0 || toMarker.opacity == 0 {
            return
        }
        let sourceLocation = "\(fromLocation.latitude),\(fromLocation.longitude)"
        let destinationLocation = "\(toLocation.latitude),\(toLocation.longitude)"
        // url для запроса для получения маршрута между двумя точками
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(sourceLocation)&destination=\(destinationLocation)&mode=driving&key=AIzaSyDxQKxlw1vUZXhmRHNaUSpVfAVUqjQEd0Y"

        // сам запрос
        AF.request(url).responseJSON { (reseponse) in
            guard let data = reseponse.data else {
                DispatchQueue.main.async {
                    var alertController: UIAlertController? = UIAlertController(title: "", message: "Не удалось простроить маршрут", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Ok", style: .cancel) { _ in
                        alertController = nil
                    }
                    alertController!.addAction(cancelAction)
                    self.present(alertController!, animated: true)
                }
                return
            }

            do {
                let jsonData = try JSON(data: data)
                let routes = jsonData["routes"].arrayValue

                for route in routes {
                    let overview_polyline = route["overview_polyline"].dictionary
                    let points = overview_polyline?["points"]?.string
                    let path = GMSPath.init(fromEncodedPath: points ?? "")
                    self.polyline.map = nil
                    self.polyline = GMSPolyline.init(path: path)
                    self.polyline.strokeColor = .systemGreen
                    self.polyline.strokeWidth = 5
                    self.polyline.map = self.googleMapView
                    DispatchQueue.main.async
                    {
                      let bounds = GMSCoordinateBounds(path: path!)
                      self.googleMapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50.0))
                    }
                }
            }
             catch let error {
                print(error.localizedDescription)
            }
        }
    }
}


extension MapViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error \(error)")
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        switch selectedLocation {
        case .fromLocation:
            fromTextField.text = "\(String(describing: place.formattedAddress!))"
            fromLocation = place.coordinate
            addMarkerCorrdinate(marker: fromMarker, at: place.coordinate)
        case .toLocation:
            toTextField.text = "\(String(describing: place.formattedAddress!))"
            toLocation = place.coordinate
            addMarkerCorrdinate(marker: toMarker, at: place.coordinate)
        }
        googleMapView.animate(to: GMSCameraPosition.camera(withTarget: place.coordinate, zoom: 15.0))
        self.dismiss(animated: true, completion: nil)
    }

    private func addMarkerCorrdinate(marker: GMSMarker, at location: CLLocationCoordinate2D) {
        marker.position = location
        marker.opacity = 1
        marker.map = googleMapView
    }

    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}



extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        marker.opacity = 0
        return true
    }

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {

    }

    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        if (fromMarker.opacity == 0) {
        addMarkerCorrdinate(marker: fromMarker, at: coordinate)
        fromLocation = coordinate
        fromTextField.text = "\(coordinate.latitude) \(coordinate.latitude)"
        } else {
            addMarkerCorrdinate(marker: toMarker, at: coordinate)
            toLocation = coordinate
            toTextField.text = "\(coordinate.latitude) \(coordinate.latitude)"
        }
    }
}
