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
    @IBOutlet weak var getRouteButton: UIButton!

    private var clear: Bool!

    let fromMarker: GMSMarker = {
        let marker = GMSMarker()
        marker.title = .from
        return marker
    }()

    let toMarker: GMSMarker = {
        let marker = GMSMarker()
        marker.title = .to
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

    lazy var polyline: GMSPolyline = {
        let polyline = GMSPolyline()
        polyline.strokeColor = .systemGreen
        polyline.strokeWidth = 5
        return polyline
    }()

    let alertController: UIAlertController = {
        let alert = UIAlertController(title: "", message: "Не удалось простроить маршрут", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        return alert
    }()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }

    private func setupUI() {
        addSubviews()
        setupConstraints()
        fromTextField.delegate = self
        toTextField.delegate = self
    }

    private func addSubviews() {
        view.addSubview(googleMapView)
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
}

extension MapViewController: PresenterToViewMapProtocol{
    func getMyLocation() -> CLLocationCoordinate2D? {
        googleMapView.myLocation?.coordinate
    }

    func swapToFrom() {
        swap(&toMarker.position, &fromMarker.position)
        swap(&fromTextField.text, &toTextField.text)
    }

    func addRoute(with path: GMSPath) {
        polyline.map = self.googleMapView
        polyline.path = path
        DispatchQueue.main.async {
          let bounds = GMSCoordinateBounds(path: path)
          self.googleMapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50.0))
        }
    }

    func showAlert() {
        DispatchQueue.main.async {
            self.present(self.alertController, animated: true)
        }
    }

    func removeMarker(title: String) {
        [fromMarker, toMarker].first{ $0.title == title }?.map = nil
    }

    func addMarker(title: String, at location: CLLocationCoordinate2D) {
        guard let marker = [fromMarker, toMarker].first(where: {$0.title == title }) else { return }
        marker.position = location
        marker.map = googleMapView
    }

    func removeRoute(){
        polyline.map = nil
    }

    func setTextFieldText(with tag: TextFieldTag, _ text: String) {
        [toTextField, fromTextField].first{ $0.tag == tag.rawValue }?.text = text
    }

    func zoom(to location: CLLocationCoordinate2D) {
        googleMapView.animate(to: GMSCameraPosition.camera(withTarget: location, zoom: 15.0))
    }
}


extension MapViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error \(error)")
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        presenter.didAutocompleteWith(place: place)
        self.dismiss(animated: true, completion: nil)
    }

    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}



extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let title = marker.title else { return true }
        presenter.didTapMarker(title: title)
        return true
    }

    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        presenter.didLongPressAt(coordinate)
    }
}

extension MapViewController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        clear = true
        presenter.textFieldShouldClear(with: TextFieldTag(rawValue: textField.tag))
        return true
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if clear == false {
            presenter.editingDidBegin(with: TextFieldTag(rawValue: textField.tag))
        }
        clear = false
        return false
    }
}
