//
//  Router.swift
//  SwiftyCompanion
//
//  Created by Маргарита Морозова on 30.04.2021.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    case getUserInformation(login: String)
    case getCoalition(userId: Int)
    case getCursusInfo
    
    static let baseURL = Constants.baseURL
    
    private var urlEncoder: ParameterEncoding {
        return Alamofire.URLEncoding()
    }
    private var jsonEncoder: ParameterEncoding {
        return Alamofire.JSONEncoding()
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getUserInformation:
            return .get
        case .getCursusInfo:
            return .get
        case .getCoalition(_):
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getUserInformation(let login):
            return "/v2/users/\(login)"
        case .getCursusInfo:
            return "/v2/cursus"
        case .getCoalition(let userId):
            return "/v2/users/\(userId)/coalitions"
        }
    }
    
    func asURLRequest() -> URLRequest {
        let requestUrl = URL(string: Router.baseURL + path) ?? URL(string: Router.baseURL + "/v2/users")
        print(Router.baseURL + path)
        var request = try! URLRequest(url: requestUrl!, method: method)
        
        let accessType = Constants.appDelegate?.auth.token?.tokenType
        let accessToken = Constants.appDelegate?.auth.token?.accessToken
        if accessToken != nil && !accessToken!.isEmpty && !accessType!.isEmpty {
            request.setValue("Bearer \(accessToken!)", forHTTPHeaderField: "Authorization")
        }

        return request
    }
}
