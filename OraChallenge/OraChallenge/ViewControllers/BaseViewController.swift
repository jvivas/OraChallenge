//
//  BaseViewController.swift
//  OraChallenge
//
//  Created by Jorge Vivas on 3/6/17.
//  Copyright © 2017 JorgeVivas. All rights reserved.
//

import UIKit
import SwiftMessages
import EGGProgressHUD

class BaseViewController: UIViewController {

    let progressHud = EGGProgressHUD()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customHud()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
