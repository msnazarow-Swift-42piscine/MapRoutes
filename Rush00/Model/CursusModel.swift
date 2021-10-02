//
//  CursusModel.swift
//  SwiftyCompanion
//
//  Created by Маргарита Морозова on 11.08.2021.
//

import Foundation
import ObjectMapper

class CursusModel: Mappable {
    var id = 0
    var name = ""
        
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
}
