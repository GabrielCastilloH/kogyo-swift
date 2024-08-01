//
//  CustomFunctions.swift
//  App1
//
//  Created by Gabriel Castillo on 6/9/24.
//

import UIKit
import Firebase

struct CustomFunctions {
    
    public static let shared = CustomFunctions()
    
    /// Returns a `TaskClass` object given task data.
    ///
    /// ```
    /// // Data must be structed as follows:
    /// let taskData: [String : Any] = [
    ///     "userUID": userUID,
    ///     "dateAdded": dateAdded,
    ///     "kind": kind,
    ///     "description": description,
    ///     "dateTime": dateTime,
    ///     "expectedHours": expectedHours,
    ///     "location": location,
    ///     "payment": payment,
    ///     "completionStatus": String, // Either: "complete", "notComplete", "inReview"
    /// ]
    /// ```
    ///
    /// - Parameters:
    ///     - for: the taskUID of the task.
    ///     - data: the actual task data.
    ///     - media: an array of `PlayableMediaView`, all the images and videos of the task.
    ///
    /// - Returns: A greeting for the given `subject`.
    public func taskFromData(for taskUID: String, data: [String : Any], media: [PlayableMediaView]) -> TaskClass {
        // This task object is completely different from the one on firebase, it has more info.
        let taskCompletion: CompletionStatus
        switch data["completion"] as? String {
        case "notComplete":
            taskCompletion = .notComplete
        case "inReview":
            taskCompletion = .inReview
        default:
            taskCompletion = .notComplete
        }
        
        let task = TaskClass(
            taskUID: taskUID,
            userUID: DataManager.shared.currentUser!.userUID,
            dateAdded: (data["dateAdded"] as? Timestamp)?.dateValue() ?? Date(),
            kind: data["kind"] as? String ?? "",
            description: data["description"] as? String ?? "",
            dateTime: (data["dateTime"] as? Timestamp)?.dateValue() ?? Date(),
            expectedHours: data["expectedHours"] as? Int ?? 0,
            location: data["location"] as? String ?? "",
            payment: data["payment"] as? Int ?? 0,
            helperUID: data["helperUID"] as? String,
            media: media,
            equipment: [],
            completionStatus: taskCompletion
        )
        
        return task
    }
    
    func createPlaceholder(for text: String) -> NSAttributedString {
        return NSAttributedString(
            string: text,
            attributes: [NSAttributedString.Key.foregroundColor: Constants().lightGrayColor.withAlphaComponent(0.5)]
        )
    }
    
    func createFormLabel(for title: String) -> UILabel {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.text = title
        return label
    }
    
    func createSeparatorView(for viewController: UIViewController, with separator: UIView, under view: UIView) {
        separator.backgroundColor = Constants().lightGrayColor.withAlphaComponent(0.3)
        
        viewController.view.addSubview(separator)
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            separator.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 20),
            separator.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor, constant: 20),
            separator.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor, constant: -20),
            separator.heightAnchor.constraint(equalToConstant: 1),
        ])
    }
}

extension UITextView {
    func leftSpace() {
        self.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 4, right: 4)
    }
}
