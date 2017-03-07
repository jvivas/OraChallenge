//
//  ChatsTableViewController.swift
//  OraChallenge
//
//  Created by Jorge Vivas on 3/5/17.
//  Copyright © 2017 JorgeVivas. All rights reserved.
//

import UIKit
import DTZFloatingActionButton

class ChatsTableViewController: BaseTableViewController {

    var chatsManager: ChatsManager? = nil
    var arrayAllChats : ChatList?
    
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
            self.performSegue(withIdentifier: "segueShowChatDetail", sender: self)
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
        self.performSegue(withIdentifier: "segueShowChatDetail", sender: self)
    }
    
    //     MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueShowChatDetail" ,
            let nextScene:ChatDetailViewController = segue.destination as? ChatDetailViewController ,
            let indexPath = self.tableView.indexPathForSelectedRow {
            let selectedChat:Chat = (self.arrayAllChats?.chats![indexPath.row])!
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
            self.arrayAllChats = chatList
            self.tableView.reloadData()
        }
    }
}
