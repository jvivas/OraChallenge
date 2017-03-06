//
//  UsersManager.swift
//  OraChallenge
//
//  Created by Jorge Vivas on 3/5/17.
//  Copyright © 2017 JorgeVivas. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

@objc protocol UsersDelegate {
    @objc optional func onCreateUserResponse(user:User?, errorMessage:String?)
}
    
class UsersManager: APIManager {
    let pathUsers = "users"
    var delegate:UsersDelegate?
    
    func requestCreate(name:String, email:String, password:String, passwordConfirmation:String) {
        let parameters: Parameters = ["name" : name, "email": email, "password": password, "password_confirmation" : passwordConfirmation]
        request(path: pathUsers, method: .post, parameters: parameters, onSuccess: { (response: SwiftyJSON.JSON) in
            let user = User(json: response["data"])
            self.delegate?.onCreateUserResponse!(user: user, errorMessage: nil)
        }, onFailed: { (response: String, statusCode:Int) in
            self.delegate?.onCreateUserResponse!(user: nil, errorMessage: response)
        })
    }
}
