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
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.text = "Loading..."
        label.numberOfLines = 2
        return label
    }()
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = .systemRed
        return sv
    }()
    
    private let contentView: UIView = {
        let v = UIView()
        v.backgroundColor = .purple
        return v
    }()
    
    // NOTE: for the job category button, you will need to add a transparent button over the view you have. 
    
    
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
        
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        let wConst = contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        wConst.isActive = true
        wConst.priority = UILayoutPriority(50)
//        
//        let electricalJob = JobCategoryView(title: "")
//        
//        contentView.addSubview(electricalJob)

        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: self.topAnchor, constant: 35),
            header.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            
            // The scroll view should be the area you want the user to be able to scroll in.
            scrollView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 10),
            scrollView.heightAnchor.constraint(equalToConstant: 140),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
            
        ])
    }

}
