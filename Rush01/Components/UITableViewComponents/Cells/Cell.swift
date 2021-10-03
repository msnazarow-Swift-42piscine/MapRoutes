//
//  Cell.swift
//  Rush01
//
//  Created by out-nazarov2-ms on 03.10.2021.
//  
//

import UIKit

class Cell: UITableViewCell, ModelRepresentable {
    weak var presenter: CellToPresenterMapProtocol!

    var model: Identifiable? {
        didSet {
            updateViews()
        }
    }

    func updateViews() {}
}
