//
//  ChatMessagesList.swift
//  OraChallenge
//
//  Created by Jorge Vivas on 3/6/17.
//  Copyright © 2017 JorgeVivas. All rights reserved.
//

import UIKit

class ChatMessagesList: NSObject {

    var chatMessages : [ChatMessage]?
    var pagination : Pagination?
    
    required init?(chatMessages: [ChatMessage], pagination: Pagination) {
        self.chatMessages = chatMessages
        self.pagination = pagination
    }
}
