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
    func clearFrom()
    func clearTo()
    func myLocationFrom()
    func myLocationTo()
    func swapToFrom()
    func openAutocomplete(with location: toFromLocation)
    func getRoute()
}


// MARK: View Input (View -> Presenter)
protocol ViewToPresenterMapProtocol: AnyObject {
    var dataSource:PresenterToDataSourceMapProtocol { get }

    func viewDidLoad()
    func buttonDidTapped(with tag: ButtonTag!)
    func editingDidBegin(with tag: TextFieldTag!)
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
