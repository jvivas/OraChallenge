//
//  CreateChatViewController.swift
//  OraChallenge
//
//  Created by Jorge Vivas on 3/6/17.
//  Copyright © 2017 JorgeVivas. All rights reserved.
//

import UIKit

@objc protocol CreateChatPopupDelegate {
    @objc optional func onCreateChat(name: String, message:String)
}


class CreateChatViewController: BaseViewController {

    var delegate: CreateChatPopupDelegate?
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldMessage: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "New chat";
        self.contentSizeInPopup = CGSize(width: 300, height: 200)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onTapCreateChat(_ sender: Any) {
        view.endEditing(true)
        if isValidData() {
            dismiss(animated: true, completion: nil)
            delegate?.onCreateChat!(name: textFieldName.text!, message: textFieldMessage.text!)
        }
    }
    
    func isValidData() -> Bool {
        if !isValidText(text: textFieldName.text!) {
            showErrorMessage(message: "Please enter a name")
            return false
        }
        if !isValidText(text: textFieldMessage.text!) {
            showErrorMessage(message: "Please enter a message")
            return false
        }
        return true
    }
}
