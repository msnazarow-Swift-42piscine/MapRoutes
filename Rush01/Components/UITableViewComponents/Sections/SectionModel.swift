//
//  SectionModel.swift
//  Rush01
//
//  Created by out-nazarov2-ms on 03.10.2021.
//  
//

import Foundation

final class SectionModel: SectionRowsRepresentable {
    var rows: [CellIdentifiable] = []

    init(_ properties: [Model]) {
        properties.forEach { property in
            rows.append(CellModel(property))
        }
    }
}
