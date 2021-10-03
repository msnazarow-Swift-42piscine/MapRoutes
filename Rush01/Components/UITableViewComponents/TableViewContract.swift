//
//  TableViewContract.swift
//  Rush01
//
//  Created by out-nazarov2-ms on 03.10.2021.
//  
//

import Foundation

protocol CellValueHeightProtocol {
    var cellHeight: Float { get }
}

typealias CellIdentifiable = Identifiable & CellValueHeightProtocol

protocol SectionRowsRepresentable {
    var rows: [CellIdentifiable] { get set }
}

extension CellValueHeightProtocol {
    var automaticHeight: Float { return -1.0 }

    var identifier: String { return "" }

    var cellHeight: Float { return automaticHeight }
}
