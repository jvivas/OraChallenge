//
//  ChatList.swift
//  OraChallenge
//
//  Created by Jorge Vivas on 3/6/17.
//  Copyright © 2017 JorgeVivas. All rights reserved.
//

import UIKit

class ChatList: NSObject {

    var chats : [Chat]?
    var pagination : Pagination?
    
    required init?(chats: [Chat], pagination: Pagination) {
        self.chats = chats
        self.pagination = pagination
    }
}
