//
//  Chat.swift
//  OraChallenge
//
//  Created by Jorge Vivas on 3/6/17.
//  Copyright © 2017 JorgeVivas. All rights reserved.
//

import UIKit
import SwiftyJSON

class Chat: NSObject {

    var id: Int?
    var name: String?
    var users : [User]?
    var lastMessage : ChatMessage?
    
    required init?(json: SwiftyJSON.JSON) {
        self.id = json["id"].int
        self.name = json["name"].string
        self.lastMessage = ChatMessage(json: json["last_chat_message"])
        var users = [User]()
        if let items = json["users"].array {
            for item in items {
                if let user = User(json: item) {
                    users.append(user)
                }
            }
        }
        self.users = users
    }
    
    func getLastMessageAuthorWithTime() -> String {
        return "\((lastMessage?.user?.name!)!) - \(getTimeDifference())"
    }
    
    func getTimeDifference() -> String {
        return getLastMessageFormatterDate().differenceBetweenDate()
    }
    
    func getLastMessageFormatterDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from:(lastMessage?.createdAt!)!)
        return date!
    }
}
