//
//  CustomFunctions.swift
//  App1
//
//  Created by Gabriel Castillo on 6/9/24.
//

import UIKit

struct CustomFunctions {
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
}

extension UITextView {
    func leftSpace() {
        self.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 4, right: 4)
    }
}
