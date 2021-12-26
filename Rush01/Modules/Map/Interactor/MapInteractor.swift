//
//  MapInteractor.swift
//  Rush01
//
//  Created by out-nazarov2-ms on 03.10.2021.
//  
//

import Alamofire
import SwiftyJSON
import GoogleMaps
import GooglePlaces

enum LocationError: Error {
    case noRoutes
}

class MapInteractor: PresenterToInteractorMapProtocol {
    func getRoute(from fromLocation: CLLocationCoordinate2D, to toLocation: CLLocationCoordinate2D, walk: Bool, complition: @escaping (Result<GMSPath, Error>) -> Void) {
        let sourceLocation = "\(fromLocation.latitude),\(fromLocation.longitude)"
        let destinationLocation = "\(toLocation.latitude),\(toLocation.longitude)"

        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "maps.googleapis.com"
        urlComponents.path = "/maps/api/directions/json"
        urlComponents.queryItems = [
            URLQueryItem(name: "origin", value: sourceLocation),
            URLQueryItem(name: "destination", value: destinationLocation),
            URLQueryItem(name: "mode", value: walk ? "walking" : "driving"),
            URLQueryItem(name: "key", value: "AIzaSyDxQKxlw1vUZXhmRHNaUSpVfAVUqjQEd0Y")
        ]
        AF.request(urlComponents.url!).responseJSON { (response) in
           guard let data = response.data else {
               if let error = response.error {
                   complition(.failure(error))
               } else {
                   complition(.failure(LocationError.noRoutes))
               }
               return
           }
           do {
               let jsonData = try JSON(data: data)
               let routes = jsonData["routes"].arrayValue
               guard !routes.isEmpty else {
                   complition(.failure(LocationError.noRoutes))
                   return
               }
               for route in routes {
                   let overview_polyline = route["overview_polyline"].dictionary
                   let points = overview_polyline?["points"]?.string
                   let path = GMSPath.init(fromEncodedPath: points ?? "")
                   if let path = path {
                    complition(.success(path))
                   } else {
                       complition(.failure(LocationError.noRoutes))
                   }
               }
           }
            catch {
                complition(.failure(error))
           }
       }
   }
}
