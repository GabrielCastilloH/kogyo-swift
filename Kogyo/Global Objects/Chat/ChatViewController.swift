//
//  ChatViewController.swift
//  Kogyo
//
//  Created by Gabriel Castillo on 8/3/24.
//

import UIKit
import MessageKit

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

struct Sender: SenderType {
    var photoURL: String
    var senderId: String
    var displayName: String
}

class ChatViewController: MessagesViewController {
    
    private var messages = [Message]()
    private let selfSender = Sender(photoURL: "", senderId: "1", displayName: "Supdabig")
    
    override func viewDidLoad() {
        
        // Initialize messages with unique IDs
        self.messages = [
            Message(sender: selfSender,
                    messageId: UUID().uuidString, // Unique ID
                    sentDate: Date(),
                    kind: .text("hello world msg")),
            Message(sender: selfSender,
                    messageId: UUID().uuidString, // Unique ID
                    sentDate: Date(),
                    kind: .text("hello world msg")),
            Message(sender: selfSender,
                    messageId: UUID().uuidString, // Unique ID
                    sentDate: Date(),
                    kind: .text("hello world msg")),
            Message(sender: selfSender,
                    messageId: UUID().uuidString, // Unique ID
                    sentDate: Date(),
                    kind: .text("hello world 2"))
        ]
        
        self.view.backgroundColor = .red
        self.messagesCollectionView.messagesDataSource = self
        self.messagesCollectionView.messagesLayoutDelegate = self
        self.messagesCollectionView.messagesDisplayDelegate = self
        
        super.viewDidLoad()
        self.setupNavBar()
        
        print(messages)
    }
    
    private func setupNavBar() {
        self.navigationController?.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .semibold)]
        self.navigationItem.title = "Chat"
    }
}

extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    var currentSender: SenderType {
        return self.selfSender
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
}
