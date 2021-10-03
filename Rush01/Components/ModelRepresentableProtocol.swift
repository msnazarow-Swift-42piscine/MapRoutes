//
//  ModelRepresentableProtocol.swift
//  Rush01
//
//  Created by out-nazarov2-ms on 03.10.2021.
//  
//

import Foundation

protocol ModelRepresentable {
    var model: Identifiable? { get set }
}

protocol Identifiable {
    var identifier: String { get }
}
