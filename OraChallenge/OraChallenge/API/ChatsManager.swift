//

//  ChatsManager.swift
//  OraChallenge
//
//  Created by Jorge Vivas on 3/6/17.
//  Copyright © 2017 JorgeVivas. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

@objc protocol ChatsDelegate {
    @objc optional func onGetChats(chatList:ChatList?, errorMessage:String?)
}

class ChatsManager: APIManager {
    var delegate: ChatsDelegate?
    let pathChats = "chats"
    
    
    func requestGetChats(page: Int, limit: Int) {
        let url = "\(pathChats)?page=\(page)&limit=\(limit)"
        request(path: url, method: .get, parameters: nil, onSuccess: { (response: SwiftyJSON.JSON) in
            print("Response: \(response)")
            var chats = [Chat]()
            if let items = response["data"].array {
                for item in items {
                    if let chat = Chat(json: item) {
                        print("Chat message \(chat)")
                        chats.append(chat)
                    }
                }
            }
            let pagination = Pagination(json: response["meta"]["pagination"])
            let chatList = ChatList(chats: chats, pagination: pagination!)
            self.delegate?.onGetChats!(chatList: chatList, errorMessage: nil)
        }, onFailed: { (response: String, statusCode:Int) in
//            self.delegate?.onCreateUserResponse!(user: nil, errorMessage: response)
            print("Response: \(response)")
        })
    }
    
    
}
