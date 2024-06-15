//
//  CustomFunctions.swift
//  App1
//
//  Created by Gabriel Castillo on 6/9/24.
//

import UIKit

struct CustomFunctions {
    
    public static let shared = CustomFunctions()
    
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
