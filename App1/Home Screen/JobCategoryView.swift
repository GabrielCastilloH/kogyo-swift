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
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .systemRed
        return scrollView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.backgroundColor = .purple
        return stackView
    }()
    
    private let dummyView1: UIView = {
        let view = UIView()
        view.backgroundColor = .systemPink
        return view
        
    }()
    
    private let dummyView2: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        return view
        
    }()
    
    private let dummyView3: UIView = {
        let view = UIView()
        view.backgroundColor = .systemMint
        return view
        
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
        
        self.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        stackView.addArrangedSubview(dummyView1)
        dummyView1.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(dummyView2)
        dummyView2.translatesAutoresizingMaskIntoConstraints = false

        stackView.addArrangedSubview(dummyView3)
        dummyView3.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: self.topAnchor, constant: 35),
            header.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            
            scrollView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 5),
            scrollView.heightAnchor.constraint(equalToConstant: 160),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
//            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            
            dummyView1.widthAnchor.constraint(equalToConstant: 150),
            dummyView2.widthAnchor.constraint(equalToConstant: 150),
            dummyView3.widthAnchor.constraint(equalToConstant: 150),
            
            
        ])
    }

    

}
