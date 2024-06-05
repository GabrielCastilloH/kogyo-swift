//
//  JobCategoryView.swift
//  App1
//
//  Created by Gabriel Castillo on 6/4/24.
//

import UIKit

class JobCategoryView: UIView {

    // MARK: - UI Components
    private let header: UILabel = {
        let header = UILabel()
        header.textColor = .label
        header.textAlignment = .left
        header.font = .systemFont(ofSize: 25, weight: .bold)
        header.text = "Loading..."
        header.numberOfLines = 2
        return header
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    
    // MARK: - Life Cycle
    init(title: String) {
        super.init(frame: .zero)
        header.text = title
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.addSubview(header)
        header.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        self.addSubview(scrollView)
        
        let view1 = JobButton(title: "dud you suck")
        let view2 = JobButton(title: "dud")
        let view3 = JobButton(title: "you")
        let view4 = JobButton(title: "really suck")
        
        stackView.addArrangedSubview(view1)
        stackView.addArrangedSubview(view2)
        stackView.addArrangedSubview(view3)
        stackView.addArrangedSubview(view4)
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: self.topAnchor, constant: 35),
            header.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            
            scrollView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 5),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
        ])
    }
}
