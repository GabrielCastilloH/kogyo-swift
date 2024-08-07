//
//  ChatViewController.swift
//  Kogyo
//
//  Created by Gabriel Castillo on 8/3/24.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import FirebaseFirestore

class ChatViewController: MessagesViewController {
    
    let currentUserConvoUID: String
    let selectedTask: TaskClass
    let selfSender: Sender
    
    private var messages = [Message]()
    private var messagesListener: ListenerRegistration?
    
    init(selectedTask: TaskClass, isHelper: Bool) {
        self.selectedTask = selectedTask
        
        let currentUserName = "\(DataManager.shared.currentUser!.firstName) \(DataManager.shared.currentUser!.lastName.prefix(1).capitalized)."
        if isHelper {
            self.currentUserConvoUID = "\(self.selectedTask.helperUID!)_helper"
            self.selfSender = Sender(photoURL: "", senderId: currentUserConvoUID, displayName: currentUserName)
        } else {
            self.currentUserConvoUID = "\(self.selectedTask.userUID)_user"
            self.selfSender = Sender(photoURL: "", senderId: currentUserConvoUID, displayName: currentUserName)
        }
        
        super.init(nibName: nil, bundle: nil)
        print("disp:",self.selfSender.displayName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        
        
        self.setupNavBar()
        
        messageInputBar.inputTextView.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Fetch initial messages
        fetchAllMessages()
        // Set up real-time listener
        setupMessagesListener()
    }
    
    private func setupNavBar() {
        self.navigationController?.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .semibold)]
        self.navigationItem.title = "Chat"
    }
    
    private func fetchAllMessages() {
        FirestoreHandler.shared.returnAllMessages(for: selectedTask) { [weak self] result in
            switch result {
            case .success(let messages):
                // Sort messages by sentDate in ascending order
                self?.messages = messages.sorted { $0.sentDate < $1.sentDate }
                DispatchQueue.main.async {
                    self?.messagesCollectionView.reloadData()
                    // Scroll to the bottom
//                    self?.messagesCollectionView.scrollToBottom(animated: true)
                    self?.messagesCollectionView.scrollToLastItem()
                }
            case .failure(let error):
                print("Error fetching messages: \(error)")
            }
        }
    }
    
    private func setupMessagesListener() {
        let db = Firestore.firestore()
        
        let storageRef = db
            .collection("users")
            .document(selectedTask.userUID)
            .collection("jobs")
            .document(selectedTask.taskUID)
            .collection("messages")
        
        messagesListener = storageRef.addSnapshotListener { [weak self] querySnapshot, error in
            if let error = error {
                print("Error listening for messages: \(error)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No messages found.")
                return
            }
            
            let newMessages = documents.compactMap { document -> Message? in
                return CustomFunctions.shared.createMessage(from: document)
            }
            
            // Update messages with new messages and reload collection view
            self?.messages = newMessages.sorted { $0.sentDate < $1.sentDate }
            DispatchQueue.main.async {
                self?.messagesCollectionView.reloadData()
                // Scroll to the bottom
                // self?.messagesCollectionView.scrollToBottom(animated: true)
                self?.messagesCollectionView.scrollToLastItem()
            }
        }
    }
    
    deinit {
        messagesListener?.remove()
    }
}

extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty else {
            return
        }
        
        // Create the message
        let message = Message(
            sender: self.selfSender,
            messageId: UUID().uuidString,
            sentDate: Date(),
            content: text,
            kind: .text(text)
        )
        
        // Clear the input bar
        inputBar.inputTextView.text = ""
        
        FirestoreHandler.shared.sendMessage(for: selectedTask, with: message) { success in
            if success {
                // Optionally fetch and reload messages after sending
                self.fetchAllMessages()
            } else {
                print("Failed to send message.")
                // Handle error (e.g., show an alert)
            }
        }
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
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return message.sender.senderId == self.selfSender.senderId ? Constants().lightBlueColor : UIColor(red: 0.89, green: 0.90, blue: 0.93, alpha: 1.00)
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: any MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        guard let message = message as? Message else {
            avatarView.image = UIImage() // Fallback image if casting fails
            return
        }
        
        let isCurrentUser = message.sender.senderId == self.selfSender.senderId
        if isCurrentUser {
            avatarView.image = DataManager.shared.currentUser!.profileImage
        } else {
            let isHelper = self.currentUserConvoUID.contains("_helper")
            if isHelper {
                avatarView.image = DataManager.shared.customers[self.selectedTask.taskUID]!.profileImage
            } else {
                avatarView.image = DataManager.shared.helpers[self.selectedTask.helperUID!]!.profileImage
            }
        }
    }
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        guard let currentMessage = message as? Message else { return 0 }
        
        if indexPath.section == 0 {
            return 20
        }
        
        if indexPath.section > 0, let previousMessage = messages[indexPath.section - 1] as? Message {
            let calendar = Calendar.current
            let difference = calendar.dateComponents([.minute], from: previousMessage.sentDate, to: currentMessage.sentDate).minute ?? 0
            let minutesPastLastHour = calendar.component(.minute, from: currentMessage.sentDate)
            let isHalfHourCrossed = (minutesPastLastHour % 30 == 0) && (minutesPastLastHour > 10)
            
            let shouldShowTimestamp = difference >= 10 || isHalfHourCrossed
            return shouldShowTimestamp ? 20 : 0
        }
        
        return 0
    }
    
    func cellBottomLabelHeight(for message: any MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        let currentMessage = messages[indexPath.section]
        let isLastMessageFromSender = indexPath.section == messages.count - 1 || (indexPath.section < messages.count - 1 && currentMessage.sender.senderId != messages[indexPath.section + 1].sender.senderId)
        
        return isLastMessageFromSender ? 20 : 0
    }
    
    func cellTopLabelAttributedText(for message: any MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        guard let message = message as? Message else { return nil }
        
        if indexPath.section == 0 {
            return createTimestampAttributedString(from: message.sentDate)
        } else if indexPath.section > 0, let previousMessage = messages[indexPath.section - 1] as? Message {
            let calendar = Calendar.current
            let difference = calendar.dateComponents([.minute], from: previousMessage.sentDate, to: message.sentDate).minute ?? 0
            let minutesPastLastHour = calendar.component(.minute, from: message.sentDate)
            let isHalfHourCrossed = (minutesPastLastHour % 30 == 0) && (minutesPastLastHour > 10)
            
            let shouldShowTimestamp = difference >= 10 || isHalfHourCrossed
            return shouldShowTimestamp ? createTimestampAttributedString(from: message.sentDate) : nil
        }
        
        return nil
    }
    
    private func createTimestampAttributedString(from date: Date) -> NSAttributedString {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let dateString = dateFormatter.string(from: date)
        return NSAttributedString(
            string: dateString,
            attributes: [
                .font: UIFont.systemFont(ofSize: 10),
                .foregroundColor: UIColor.gray
            ]
        )
    }
    
    func cellBottomLabelAttributedText(for message: any MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let currentMessage = messages[indexPath.section]
        let isLastMessageFromSender = indexPath.section == messages.count - 1 || (indexPath.section < messages.count - 1 && currentMessage.sender.senderId != messages[indexPath.section + 1].sender.senderId)
        
        return isLastMessageFromSender ? NSAttributedString(
            string: currentMessage.sender.displayName,
            attributes: [
                .font: UIFont.preferredFont(forTextStyle: .caption1),
                .foregroundColor: UIColor(white: 0.3, alpha: 1)
            ]
        ) : nil
    }
}
