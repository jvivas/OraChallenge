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
    @objc optional func onGetCurrentUser(user:User?, errorMessage:String?)
    @objc optional func onUpdateCurrentUser(user:User?, errorMessage:String?)
}
    
class UsersManager: APIManager {
    var delegate:UsersDelegate?
    let pathUsers = "users"
    let pathCurrentUser = "users/current"
    
    func requestCreate(name:String, email:String, password:String, passwordConfirmation:String) {
        let parameters: Parameters = ["name" : name, "email": email, "password": password, "password_confirmation" : passwordConfirmation]
        request(path: pathUsers, method: .post, parameters: parameters, onSuccess: { (response: SwiftyJSON.JSON) in
            let user = User(json: response["data"])
            self.delegate?.onCreateUserResponse!(user: user, errorMessage: nil)
        }, onFailed: { (response: String, statusCode:Int) in
            self.delegate?.onCreateUserResponse!(user: nil, errorMessage: response)
        })
    }
    
    func requestCurrentUser() {
        request(path: pathCurrentUser, method: .get, parameters: nil, onSuccess: { (response: SwiftyJSON.JSON) in
            let user = User(json: response["data"])
            self.delegate?.onGetCurrentUser!(user: user, errorMessage: nil)
        }, onFailed: { (response: String, statusCode:Int) in
            self.delegate?.onGetCurrentUser!(user: nil, errorMessage: response)
        })
    }
    
    func requestUpdateCurrentUser(name:String, email:String) {
        let parameters: Parameters = ["name" : name, "email": email]
        request(path: pathCurrentUser, method: .patch, parameters: parameters, onSuccess: { (response: SwiftyJSON.JSON) in
            let user = User(json: response["data"])
            self.delegate?.onUpdateCurrentUser!(user: user, errorMessage: nil)
        }, onFailed: { (response: String, statusCode:Int) in
            self.delegate?.onUpdateCurrentUser!(user: nil, errorMessage: response)
        })
    }
}
