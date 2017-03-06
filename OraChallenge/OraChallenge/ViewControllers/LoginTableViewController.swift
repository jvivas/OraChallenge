//
//  LoginTableViewController.swift
//  OraChallenge
//
//  Created by Jorge Vivas on 3/5/17.
//  Copyright © 2017 JorgeVivas. All rights reserved.
//

import UIKit

class LoginTableViewController: BaseTableViewController {

    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    
    var authManager:AuthManager? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: .zero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    @IBAction func onTapLogin(_ sender: Any) {
        if isValidData() {
            startLoader(message: "Loading")
            authManager = AuthManager.init()
            authManager?.delegate = self
            authManager!.requestLogin(email: textFieldEmail.text!, password: textFieldPassword.text!)
        }
    }
    
    func isValidData() -> Bool {
        if !isValidText(text: textFieldEmail.text!) || !(textFieldEmail.text?.isValidEmail())! {
            showErrorMessage(message: "Please enter a valid email")
            return false
        }
        if !isValidText(text: textFieldPassword.text!) {
            showErrorMessage(message: "Please enter a password")
            return false
        }
        return true
    }
}

extension LoginTableViewController : AuthDelegate {
    func onLoginResponse(user: User?, errorMessage: String?) {
        stopLoader()
        if errorMessage != nil {
            showErrorMessage(message: errorMessage!)
        } else {
            print("Success login")
        }
    }
}
