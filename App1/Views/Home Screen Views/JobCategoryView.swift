//
//  JobCategoryView.swift
//  App1
//
//  Created by Gabriel Castillo on 6/4/24.
//

import UIKit

class JobCategoryView: UIView {
    
    // MARK: - Variables
    let jobs: [JobButtonView]
    
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
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    
    // MARK: - Life Cycle
    init(title: String, jobButtons: [JobButtonView]) {
        self.jobs = jobButtons
        
        super.init(frame: .zero)
        
        header.text = title
        setupUI()
        setupJobViews()
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
        
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: self.topAnchor),
            header.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            
            scrollView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: -5),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
        ])
        
        setupJobViews()
    }
    
    func setupJobViews() {
        for job in jobs {
            
            stackView.addArrangedSubview(job)
            
            NSLayoutConstraint.activate([
                job.topAnchor.constraint(equalTo: stackView.topAnchor),
                job.widthAnchor.constraint(equalToConstant: 160),
                job.heightAnchor.constraint(equalToConstant: 160),
            ])
        }
    }
}
