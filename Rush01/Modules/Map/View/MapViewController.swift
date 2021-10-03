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

//    // MARK: - Lifecycle Methods
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        presenter?.viewDidLoad()
//    }
//
//    private func setupUI() {
//        addSubviews()
//        setupConstraints()
//    }
//
//    private func addSubviews() {
//
//    }
//
//    private func setupConstraints() {
//
//    }



    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var mapView: UIView!

    var fromLocation = CLLocationCoordinate2D()
    var toLocation = CLLocationCoordinate2D()
    var currentLocation: CLLocationCoordinate2D?
    var selectedLocation = toFromLocation.fromLocation

    let fromMarker = GMSMarker()
    let toMarker = GMSMarker()

    var googleMapView = GMSMapView()
    var camera = GMSCameraPosition()

    var polyline = GMSPolyline()

    override func viewDidLoad() {
        super.viewDidLoad()
        // camera это положение куда смотрит камера на карте, чем больше zoom, тем ближе
        // начальное положение камеры - школа в Москве
        camera = GMSCameraPosition.camera(withLatitude: 55.797, longitude: 37.580, zoom: 15.0)
        googleMapView = GMSMapView.map(withFrame: mapView.frame, camera: camera)
        googleMapView.settings.myLocationButton = true
        googleMapView.isMyLocationEnabled = true
        mapView.addSubview(googleMapView)

        fromMarker.opacity = 0
        toMarker.opacity = 0
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //совмещение фрэйма гугловской карты и вьюхи в сториборде
        googleMapView.frame = mapView.frame
    }

    // Очистка позиции from
    @IBAction func fromClearButtonAction(_ sender: UIButton) {
        fromTextField.text = ""
        polyline.map = nil
        fromMarker.opacity = 0
    }

    // Очистка позиции to
    @IBAction func toClearButtonAction(_ sender: UIButton) {
        toTextField.text = ""
        polyline.map = nil
        toMarker.opacity = 0
    }

    // Установка моей геопозиции в From
    @IBAction func myLocationForFrom(_ sender: UIButton) {
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
    @IBAction func myLocationForTo(_ sender: UIButton) {
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
    @IBAction func swapToFromButtonAction(_ sender: UIButton) {
        let newLocation = fromLocation
        fromLocation = toLocation
        fromMarker.position = toLocation
        toLocation = newLocation
        toMarker.position = newLocation
        let newTextLocation = fromTextField.text
        fromTextField.text = toTextField.text
        toTextField.text = newTextLocation
    }

    @IBAction func fromTextFieldAction(_ sender: UITextField) {
        let autoCompleteViewController = GMSAutocompleteViewController()
        autoCompleteViewController.delegate = self
        selectedLocation = .fromLocation
        self.present(autoCompleteViewController, animated: true, completion: nil)
    }

    @IBAction func toTextFieldAction(_ sender: UITextField) {
        let autoCompleteViewController = GMSAutocompleteViewController()
        autoCompleteViewController.delegate = self
        selectedLocation = .toLocation
        self.present(autoCompleteViewController, animated: true, completion: nil)
    }

    @IBAction func getRouteButtonAction(_ sender: UIButton) {
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

extension MapViewController: PresenterToViewMapProtocol{
    
}

extension MapViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error \(error)")
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        if selectedLocation == .fromLocation {
            fromTextField.text = "\(String(describing: place.formattedAddress!))"
            fromLocation = place.coordinate
            fromMarker.position = place.coordinate
            fromMarker.opacity = 1
            fromMarker.map = googleMapView
        } else {
            toTextField.text = "\(String(describing: place.formattedAddress!))"
            toLocation = place.coordinate
            toMarker.position = place.coordinate
            toMarker.opacity = 1
            toMarker.map = googleMapView
        }
        googleMapView.animate(to: GMSCameraPosition.camera(withTarget: place.coordinate, zoom: 15.0))
        self.dismiss(animated: true, completion: nil)
    }

    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}
