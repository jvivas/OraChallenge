//
//  ChatMessage.swift
//  OraChallenge
//
//  Created by Jorge Vivas on 3/6/17.
//  Copyright © 2017 JorgeVivas. All rights reserved.
//

import UIKit
import SwiftyJSON

class ChatMessage: NSObject {

    var id: Int?
    var chatId: Int?
    var userId: Int?
    var message: String?
    var createdAt: String?
    var user : User?
    
    required init?(json: SwiftyJSON.JSON) {
        self.id = json["id"].int
        self.chatId = json["chat_id"].int
        self.userId = json["user_id"].int
        self.message = json["message"].string
        self.createdAt = json["created_at"].string
        self.user = User(json: json["user"])
    }
}
