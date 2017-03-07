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
        chatsManager = ChatsManager.init()
        chatsManager?.delegate = self
        getChats(page: 1, limit: 50)
        // Do any additional setup after loading the view.
        let buttonWidth = CGFloat(44.0)
        let actionButton = DTZFloatingActionButton(frame:CGRect(x: 100,
                                                                y: 100,
                                                                width: buttonWidth,
                                                                height: buttonWidth
        ))
        actionButton.buttonColor = UIColor.orange
        actionButton.handler = {
            button in
            print("Hi!")
        }
        actionButton.isScrollView = true
        self.view.addSubview(actionButton)
        
        self.edgesForExtendedLayout = []
//        let actionButton = DTZFABManager.shared.button
//        DTZFABManager.shared.button().handler = {
//            button in
//            print("Tapped")
//        }
//        DTZFABManager.shared.show()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getChats(page: Int, limit: Int) {
        startLoader(message: "Loading...")
        chatsManager?.requestGetChats(page: page, limit: limit)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrayAllChats != nil {
//            return (self.arrayAllChats?.chats!.count)!
            return 20
        }
        return 0
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected \(indexPath.row)")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ChatTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "chatCellIdentifier") as! ChatTableViewCell!
        
//        let chat:Chat = (self.arrayAllChats?.chats![indexPath.row])!
//        cell.labelChatName.text = chat.name
//        cell.labelChatTime.text = chat.getLastMessageAuthorWithTime()
//        cell.labelMessage.text = chat.lastMessage?.message
        
        return cell
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
