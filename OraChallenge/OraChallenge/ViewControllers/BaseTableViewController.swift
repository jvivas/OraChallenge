//
//  BaseTableViewController.swift
//  OraChallenge
//
//  Created by Jorge Vivas on 3/5/17.
//  Copyright © 2017 JorgeVivas. All rights reserved.
//

import UIKit
import SwiftMessages
import EGGProgressHUD

extension String {
    func isValidEmail() -> Bool {
        
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", regex)
        return emailTest.evaluate(with: self)
    }
}

class BaseTableViewController: UITableViewController {

    let progressHud = EGGProgressHUD()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: .zero)
        customHud()
        hideKeyboardWhenTappedAround() 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func isValidText(text: String) -> Bool {
        if text.characters.count == 0 {
            return false
        }
        return true
    }
    
    func showErrorMessage(message: String) {
        let view = MessageView.viewFromNib(layout: .TabView)
        view.configureTheme(.error)
        view.button?.isHidden = true
        view.configureContent(title: "Error", body: message)
        SwiftMessages.show(config: getMessageConfig(), view: view)
    }
    
    func showSuccessMessage(message: String) {
        let view = MessageView.viewFromNib(layout: .TabView)
        view.configureTheme(.success)
        view.button?.isHidden = true
        view.configureContent(title: "Success", body: message)
        SwiftMessages.show(config: getMessageConfig(), view: view)
    }
    
    func getMessageConfig () -> SwiftMessages.Config {
        var config = SwiftMessages.defaultConfig
        config.presentationStyle = .bottom
        config.presentationContext = .window(windowLevel: UIWindowLevelNormal)
        return config
    }
    
    func customHud() {
        progressHud.type = EGGProgressHUD.ProgressType.progressWithBG
        progressHud.style = EGGProgressHUD.SpinnerStyle.white
        progressHud.bgColor = UIColor.gray
    }
    
    func startLoader(message:String) {
        progressHud.showInView(self.view)
    }
    
    func stopLoader() {
        progressHud.hide()
    }
}

extension UITableViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UITableViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
