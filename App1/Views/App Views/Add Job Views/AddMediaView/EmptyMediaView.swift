//
//  EmptyMediaView.swift
//  App1
//
//  Created by Gabriel Castillo on 6/17/24.
//

import UIKit

class EmptyMediaView: UIView {
    // MARK: - Variables
    
    
    // MARK: - UI Components
    private let borderView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    // MARK: - Life Cycle
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        borderView.addDashedBorder()
        self.addSubview(borderView)
        borderView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            borderView.topAnchor.constraint(equalTo: self.topAnchor),
            borderView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            borderView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            borderView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    
    // MARK: - Selectors
    

}
