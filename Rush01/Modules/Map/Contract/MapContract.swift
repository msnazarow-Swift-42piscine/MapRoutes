//
//  MapContract.swift
//  Rush01
//
//  Created by out-nazarov2-ms on 03.10.2021.
//  
//

import UIKit


// MARK: View Output (Presenter -> View)
protocol PresenterToViewMapProtocol: AnyObject {

}


// MARK: View Input (View -> Presenter)
protocol ViewToPresenterMapProtocol: AnyObject {
    var dataSource:PresenterToDataSourceMapProtocol { get }
    func viewDidLoad()
}


// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorMapProtocol: AnyObject {

}

// MARK: Presenter Output (Presenter -> Router)
protocol PresenterToRouterMapProtocol: AnyObject {
    
}

// MARK: Presenter Output (Presenter -> DataSource)
protocol PresenterToDataSourceMapProtocol: UITableViewDataSource {
    func updateForSections(_ sections: [SectionModel])
}

// MARK: Cell Input (Cell -> Presenter)
protocol CellToPresenterMapProtocol: AnyObject {

}
