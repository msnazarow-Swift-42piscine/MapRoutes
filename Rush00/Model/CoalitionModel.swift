//
//  CoalitionModel.swift
//  SwiftyCompanion
//
//  Created by Маргарита Морозова on 27.05.2021.
//

import Foundation
import ObjectMapper

class CoalitionModel: Mappable {
    var id = 0
    /// Название коалиции
    var name = ""
    var imageURL = ""
    var color: UIColor?
        
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        imageURL <- map["image_url"]
        var colorStr = ""
        colorStr <- map["color"]
        color = hexStringToUIColor(hex: colorStr)
    }
    
    func hexStringToUIColor (hex: String) -> UIColor {
        var colorStr: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (colorStr.hasPrefix("#")) {
            colorStr.remove(at: colorStr.startIndex)
        }

        if ((colorStr.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: colorStr).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
