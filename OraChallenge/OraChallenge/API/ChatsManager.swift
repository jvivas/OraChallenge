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
    @objc optional func onGetChatMessages(chatMessages:ChatMessagesList?, errorMessage:String?)
    @objc optional func onCreateChatMessage(chatMessage:ChatMessage?, errorMessage:String?)
    @objc optional func onCreateChat(chat:Chat?, errorMessage:String?)
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
            self.delegate?.onGetChats!(chatList: nil, errorMessage: response)
        })
    }
    
    
    func requestGetChatMessages(id:Int, page:Int, limit:Int) {
        let url = "\(pathChats)/\(id)/chat_messages?page=\(page)&limit=\(limit)"
        request(path: url, method: .get, parameters: nil, onSuccess: { (response: SwiftyJSON.JSON) in
            print("Response: \(response)")
            var chatMessages = [ChatMessage]()
            if let items = response["data"].array {
                for item in items {
                    if let chatMessage = ChatMessage(json: item) {
                        print("Chat message \(chatMessage)")
                        chatMessages.append(chatMessage)
                    }
                }
            }
            let pagination = Pagination(json: response["meta"]["pagination"])
            let chatMessagesList = ChatMessagesList(chatMessages: chatMessages, pagination: pagination!)
            self.delegate?.onGetChatMessages!(chatMessages: chatMessagesList, errorMessage: nil)
        }, onFailed: { (response: String, statusCode:Int) in
            self.delegate?.onGetChatMessages!(chatMessages: nil, errorMessage: response)
        })
    }
    
    func requestCreateChatMessage(chatId:Int, message:String) {
        let parameters: Parameters = [ "message": message]
        let url = "\(pathChats)/\(chatId)/chat_messages"
        request(path: url, method: .post, parameters: parameters, onSuccess: { (response: SwiftyJSON.JSON) in
            print("Response: \(response)")
            let chatMessage = ChatMessage(json: response["data"])
            self.delegate?.onCreateChatMessage!(chatMessage: chatMessage, errorMessage: nil)
        }, onFailed: { (response: String, statusCode:Int) in
            self.delegate?.onCreateChatMessage!(chatMessage: nil, errorMessage: response)
        })
    }
    
    func requestCreateChat(name:String, message:String) {
        let parameters: Parameters = ["name" : name, "message": message]
        request(path: pathChats, method: .post, parameters: parameters, onSuccess: { (response: SwiftyJSON.JSON) in
            print("Response: \(response)")
            let chat = Chat(json: response["data"])
            self.delegate?.onCreateChat!(chat: chat, errorMessage: nil)
        }, onFailed: { (response: String, statusCode:Int) in
            self.delegate?.onCreateChat!(chat: nil, errorMessage: response)
        })
    }

    
    
}
