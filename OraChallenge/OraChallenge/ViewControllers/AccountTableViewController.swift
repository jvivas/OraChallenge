//
//  AccountTableViewController.swift
//  OraChallenge
//
//  Created by Jorge Vivas on 3/5/17.
//  Copyright © 2017 JorgeVivas. All rights reserved.
//

import UIKit

class AccountTableViewController: BaseTableViewController {

    
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    
    var usersManager: UsersManager? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        usersManager = UsersManager.init()
        usersManager?.delegate = self
        getCurrentUserData()
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
    
    @IBAction func onTapSaveUserInfo(_ sender: Any) {
        if isValidData() {
            dismissKeyboard()
            startLoader(message: "Loading...")
            usersManager?.requestUpdateCurrentUser(name: textFieldName.text!, email: textFieldEmail.text!)
        }
    }
    
    func getCurrentUserData() {
        startLoader(message: "Loading...")
        usersManager?.requestCurrentUser()
    }
    
    func updateUIWithUserData(user: User?) {
        if user != nil {
            textFieldName.text = user!.name
            textFieldEmail.text = user!.email
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
        return true
    }
}

extension AccountTableViewController : UsersDelegate {
    func onGetCurrentUser(user:User?, errorMessage:String?) {
        stopLoader()
        if errorMessage != nil {
            showErrorMessage(message: errorMessage!)
        } else {
            updateUIWithUserData(user: user)
        }
    }
    
    func onUpdateCurrentUser(user:User?, errorMessage:String?) {
        stopLoader()
        if errorMessage != nil {
            showErrorMessage(message: errorMessage!)
        } else {
            updateUIWithUserData(user: user)
            showSuccessMessage(message: "The data has been saved")
        }
    }
}
