//
//  MainScreenViewController.swift
//  SwiftyCompanion
//
//  Created by Маргарита Морозова on 27.04.2021.
//

import UIKit

class MainScreenViewController: UIViewController {

//    var userInformation: UserInformationModel?
    //MARK: Outlets
    @IBOutlet weak var searchLoginOutlet: UISearchBar!
    @IBOutlet weak var searchButtonOutlet: UIButton!
    private var alertController: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        setupScreen()
    }
    
    private func setupScreen() {
        searchButtonOutlet.backgroundColor = .purple
        searchButtonOutlet.layer.cornerRadius = 15
        searchButtonOutlet.setTitleColor(.white, for: .normal)
        searchButtonOutlet.setTitle(NSLocalizedString("Поиск", comment: ""), for: .normal)
    }
    
    @IBAction func searchButtonAction(_ sender: UIButton) {
        if let login = searchLoginOutlet.text {
            Constants.appDelegate?.auth.getDataUser(login: login.lowercased()) { result, error in
                if error == nil && result != nil {
                    Constants.appDelegate?.auth.getCoalition(userId: result!.id) { coalitions, errorCoal in
                        if errorCoal == nil && coalitions != nil {
                            let viewController = ScreenInformationAssembly.screenInformationViewController(userInformation: result!, coalitionInformation: coalitions!)
                            self.present(viewController, animated: true, completion: nil)
                        } else {
                            print("Error: \(errorCoal)")
                        }
                    }
                } else {
                    guard self.alertController == nil else { return }
                    self.alertController = self.makeAlert(login: login, message: NSLocalizedString("Пользователь с ником", comment: "") + " \(login) " + NSLocalizedString("не найден", comment: ""))
                    guard let alert = self.alertController else { return }
                    self.present(alert, animated: true)
                    print("Error: \(error)")
                }
            }
        }
    }
    
    private func setupConstraints() {
        searchLoginOutlet.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.frame.height/2 - 30).isActive = true
    }
    
    func makeAlert(login: String, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel) { _ in
            self.alertController = nil
        }
        alertController.addAction(cancelAction)
        return alertController
    }
}
