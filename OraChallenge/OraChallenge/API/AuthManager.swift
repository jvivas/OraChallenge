//
//  AuthManager.swift
//  OraChallenge
//
//  Created by Jorge Vivas on 3/5/17.
//  Copyright © 2017 JorgeVivas. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

@objc protocol AuthDelegate {
    @objc optional func onLoginResponse(user:User?, errorMessage:String?)
    @objc optional func onLogoutResponse()
}

class AuthManager: APIManager {
    let pathLogin = "auth/login"
    var delegate:AuthDelegate?
    
    func requestLogin(email:String, password:String) {
        let parameters: Parameters = [ "email": email, "password": password]
        request(path: pathLogin, method: .post, parameters: parameters, onSuccess: { (response: SwiftyJSON.JSON) in
            let user = User(json: response["data"])
            DefaultsManager.saveUserId(userId: (user?.id)!)
            self.delegate?.onLoginResponse!(user: user, errorMessage: nil)
        }, onFailed: { (response: String, statusCode:Int) in
            self.delegate?.onLoginResponse!(user: nil, errorMessage: response)
        })
    }
}
