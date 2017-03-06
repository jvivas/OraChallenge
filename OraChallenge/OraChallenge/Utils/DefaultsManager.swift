//
//  DefaultsManager.swift
//  OraChallenge
//
//  Created by Jorge Vivas on 3/5/17.
//  Copyright © 2017 JorgeVivas. All rights reserved.
//

import UIKit

class DefaultsManager: NSObject {
    
    static let key_token = "user_auth_token"
    
    static func saveAuthToken(token:String) {
        UserDefaults.standard.setValue(token, forKey: key_token)
    }
    
    static func getAuthToken() -> String {
        return UserDefaults.standard.value(forKey: key_token) as! String
    }
}
