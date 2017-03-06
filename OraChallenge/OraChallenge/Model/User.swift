//
//  User.swift
//  OraChallenge
//
//  Created by Jorge Vivas on 3/5/17.
//  Copyright © 2017 JorgeVivas. All rights reserved.
//

import UIKit
import SwiftyJSON

class User : NSObject {
    var id: Int?
    var name: String?
    var email: String?
    
    required init?(json: SwiftyJSON.JSON) {
        self.name = json["name"].string
        self.id = json["id"].int
        self.email = json["email"].string
    }
}
