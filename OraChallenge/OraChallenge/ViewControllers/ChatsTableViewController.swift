//
//  ChatsTableViewController.swift
//  OraChallenge
//
//  Created by Jorge Vivas on 3/5/17.
//  Copyright © 2017 JorgeVivas. All rights reserved.
//

import UIKit
import DTZFloatingActionButton
import STPopup

class ChatsTableViewController: BaseTableViewController {

    var chatsManager : ChatsManager? = nil
    var arrayAllChats : ChatList?
    var selectedChat : Chat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addFloatingButton()
        self.edgesForExtendedLayout = []
        chatsManager = ChatsManager.init()
        chatsManager?.delegate = self
        getChats(page: 1, limit: 50)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getChats(page: Int, limit: Int) {
        startLoader(message: "Loading...")
        chatsManager?.requestGetChats(page: page, limit: limit)
    }
    
    func addFloatingButton() {
        let buttonWidth = CGFloat(44.0)
        let buttonAddChat = DTZFloatingActionButton(frame:CGRect(x: 100,
                                                                y: 100,
                                                                width: buttonWidth,
                                                                height: buttonWidth
        ))
        buttonAddChat.buttonColor = UIColor.orange
        buttonAddChat.handler = {
            button in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController : CreateChatViewController = storyboard.instantiateViewController(withIdentifier: "createChatViewControllerId") as! CreateChatViewController
            viewController.delegate = self
            let popupController : STPopupController = STPopupController.init(rootViewController: viewController)
            popupController.present(in: self)
        }
        buttonAddChat.isScrollView = true
        self.view.addSubview(buttonAddChat)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrayAllChats != nil {
            return (self.arrayAllChats?.chats!.count)!
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ChatTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "chatCellIdentifier") as! ChatTableViewCell!
        
        let chat:Chat = (self.arrayAllChats?.chats![indexPath.row])!
        cell.labelChatName.text = chat.name
        cell.labelChatTime.text = chat.getLastMessageAuthorWithTime()
        cell.labelMessage.text = chat.lastMessage?.message
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatByIndex:Chat = (self.arrayAllChats?.chats![indexPath.row])!
        selectedChat = chatByIndex
        self.performSegue(withIdentifier: "segueShowChatDetail", sender: self)
    }
    
    //     MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueShowChatDetail" {
            let nextScene:ChatDetailViewController = (segue.destination as? ChatDetailViewController)!
            nextScene.currentChatDetail = selectedChat
        }
    }
}

extension ChatsTableViewController :  ChatsDelegate {
    func onGetChats(chatList:ChatList?, errorMessage:String?) {
        stopLoader()
        if errorMessage != nil {
            showErrorMessage(message: errorMessage!)
        } else {
            arrayAllChats = chatList
            tableView.reloadData()
        }
    }
    
    func onCreateChat(chat: Chat?, errorMessage: String?) {
        stopLoader()
        if errorMessage != nil {
            showErrorMessage(message: errorMessage!)
        } else {
            arrayAllChats?.chats?.append(chat!)
            selectedChat = chat
            self.performSegue(withIdentifier: "segueShowChatDetail", sender: self)
            tableView.reloadData()
        }
    }
}

extension ChatsTableViewController: CreateChatPopupDelegate {
    func onCreateChat(name: String, message: String) {
        startLoader(message: "Loading...")
        chatsManager?.requestCreateChat(name: name, message: message)
    }
}
