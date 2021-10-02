//
//  UserCourseModel.swift
//  SwiftyCompanion
//
//  Created by Маргарита Морозова on 29.04.2021.
//

import Foundation
import ObjectMapper

class UserCourseModel: Mappable {
    var id = 0
    var level: Double = 0.0
    var grade = ""
    var skills: [SkillsModel] = []
    var cursus: CursusModel? = nil
        
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        level <- map["level"]
        grade <- map["grade"]
        skills <- map["skills"]
        cursus <- map["cursus"]
    }
}
