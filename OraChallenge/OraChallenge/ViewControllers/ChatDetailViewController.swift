//
//  ChatDetailViewController.swift
//  OraChallenge
//
//  Created by Jorge Vivas on 3/6/17.
//  Copyright © 2017 JorgeVivas. All rights reserved.
//

import UIKit

class ChatDetailViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var commentView: DCCommentView?
    var chatsManager: ChatsManager? = nil
    var arrayAllMessages : ChatMessagesList?
    var currentChatDetail : Chat?
    var currentUserId : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentUserId = DefaultsManager.getUserId()
        chatsManager = ChatsManager.init()
        chatsManager?.delegate = self
        getMessages(page: 1, limit: 50)
        addTextField()
        self.edgesForExtendedLayout = []
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getMessages(page:Int, limit:Int) {
        if currentChatDetail != nil {
            startLoader(message: "Loading...")
            chatsManager?.requestGetChatMessages(id: (currentChatDetail?.id)!, page: page, limit: limit)
        }
    }

    func getStringSizeForFont(font: UIFont, myText: String) -> CGSize {
        let fontAttributes = [NSFontAttributeName: font]
        let size = (myText as NSString).size(attributes: fontAttributes)
        return size
    }
    
    func addTextField() {
        commentView = DCCommentView.init(scrollView: tableView, frame: self.view.bounds)
        commentView?.delegate = self
        commentView?.charLimit = 200
        self.view.addSubview(commentView!)
        commentView?.tintColor = UIColor.black
    }
}

extension ChatDetailViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrayAllMessages != nil {
            return (self.arrayAllMessages?.chatMessages!.count)!
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chatMessage:ChatMessage = (self.arrayAllMessages?.chatMessages![indexPath.row])!
        if currentUserId == chatMessage.userId {
            let cell:ChatMessageRightTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "chatMessageRightCellId") as! ChatMessageRightTableViewCell!
            cell.labelChatDetail?.text = chatMessage.message
            cell.labelAuthorAndTime.text = chatMessage.getAuthorWithTime()
            return cell
        } else {
            let cell:ChatMessageLeftTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "chatMessageLeftCellId") as! ChatMessageLeftTableViewCell!
            cell.labelChatDetail?.text = chatMessage.message
            cell.labelAuthorAndTime.text = chatMessage.getAuthorWithTime()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let chatMessage:ChatMessage = (self.arrayAllMessages?.chatMessages![indexPath.row])!
        let stringSizeAsText: CGSize = getStringSizeForFont(font: UIFont.systemFont(ofSize: 17.0), myText: chatMessage.message!)
        let labelWidth: CGFloat = 203.0
        let originalLabelHeight: CGFloat = 21.0
        let labelLines: CGFloat = CGFloat(ceil(Float(stringSizeAsText.width/labelWidth)))
        let height =  tableView.rowHeight - originalLabelHeight + CGFloat(labelLines*stringSizeAsText.height) + 94.0
        return height
    }
}

extension ChatDetailViewController : ChatsDelegate {
    func onGetChatMessages(chatMessages: ChatMessagesList?, errorMessage: String?) {
        stopLoader()
        if errorMessage != nil {
            showErrorMessage(message: errorMessage!)
        } else {
            self.arrayAllMessages = chatMessages
            self.tableView.reloadData()
        }
    }
    
    func onCreateChatMessage(chatMessage:ChatMessage?, errorMessage:String?) {
        stopLoader()
        if errorMessage != nil {
            showErrorMessage(message: errorMessage!)
        } else {
            commentView?.sendFinished("")
            self.arrayAllMessages?.chatMessages?.append(chatMessage!)
            self.tableView.reloadData()
        }
    }
}

extension ChatDetailViewController : DCCommentViewDelegate {
    func didSendComment(_ text: String!) {
        view.endEditing(true)
        if text != nil {
            startLoader(message: "Loading...")
            chatsManager?.requestCreateChatMessage(chatId: (currentChatDetail?.id)!, message: text)
        }
    }
}
