//
//  RegisterTableViewController.swift
//  OraChallenge
//
//  Created by Jorge Vivas on 3/5/17.
//  Copyright © 2017 JorgeVivas. All rights reserved.
//

import UIKit

class RegisterTableViewController: BaseTableViewController {

    
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldConfirmPassword: UITextField!
    
    var usersManager: UsersManager? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usersManager = UsersManager.init()
        usersManager?.delegate = self
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
        return 4
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    @IBAction func onTapLoginButton(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    

    @IBAction func onTapRegisterButton(_ sender: Any) {
        if isValidData() {
            startLoader(message: "Loading...")
            usersManager?.requestCreate(name: textFieldName.text!, email: textFieldEmail.text!, password: textFieldPassword.text!, passwordConfirmation: textFieldConfirmPassword.text!)
        }
    }
    
    func isValidData() -> Bool {
        if !isValidText(text: textFieldName.text!) {
            showErrorMessage(message: "Please enter a name")
            return false
        }
        if !isValidText(text: textFieldEmail.text!) || !(textFieldEmail.text?.isValidEmail())! {
            showErrorMessage(message: "Please enter a valid email")
            return false
        }
        if !isValidText(text: textFieldPassword.text!) {
            showErrorMessage(message: "Please enter a password")
            return false
        }
        if !isValidText(text: textFieldConfirmPassword.text!) {
            showErrorMessage(message: "Please confirm your password")
            return false
        }
        if textFieldPassword.text! != textFieldConfirmPassword.text! {
            showErrorMessage(message: "Please enter the same password")
            return false
        }
        return true
    }
}

extension RegisterTableViewController : UsersDelegate {
    func onCreateUserResponse(user:User?, errorMessage:String?) {
        stopLoader()
        if errorMessage != nil {
            showErrorMessage(message: errorMessage!)
        } else {
            // TODO show next screen
            print("Success created user")
        }
    }
}
