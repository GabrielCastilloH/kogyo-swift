//
//  CurrentJobsController.swift
//  App1
//
//  Created by Gabriel Castillo on 6/4/24.
//

import UIKit

class CurrentJobsController: UIViewController {
    
    // MARK: - Variables
    var currentJobs = CurrentJobs()
    
    // MARK: - UI Components
    private let currentJobsTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.keyboardDismissMode = .onDrag
        tableView.allowsSelection = true
        tableView.register(CurrentJobsCell.self, forCellReuseIdentifier: CurrentJobsCell.identifier)
        return tableView
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        let jobHelper = Helper(
            name: "John D.",
            profileImageName: "Cleaning",
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer ullamcorper dui in maximus pharetra. Integer faucibus massa eget nibh consequat, egestas ullamcorper purus tempor. Sed consectetur interdum dolor quis scelerisque. Suspendisse nunc augue, ultrices ut tortor eu, luctus efficitur ex. Morbi hendrerit faucibus nisi, id ultrices augue vestibulum eget. Vestibulum convallis porttitor nunc vel luctus. Nam varius, est eget iaculis accumsan, nunc ex blandit augue, vel semper ex metus non erat. Maecenas dictum condimentum ipsum. Praesent pharetra elit sed rutrum dignissim. Nunc interdum odio at mi volutpat, ut accumsan nulla consequat. Nullam ac tincidunt eros, vel sodales libero. Duis scelerisque varius interdum. Donec vitae tincidunt lacus, sit amet varius purus. Aenean scelerisque ex eu diam bibendum, rutrum posuere nulla placerat."
                           )
        
        currentJobs.allJobs.append(
            Job(
                kind: "Cleaning",
                description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer ullamcorper dui in maximus pharetra. Integer faucibus massa eget nibh consequat, egestas ullamcorper purus tempor. Sed consectetur interdum dolor quis scelerisque. Suspendisse nunc augue, ultrices ut tortor eu, luctus efficitur ex. Morbi hendrerit faucibus nisi, id ultrices augue vestibulum eget. Vestibulum convallis porttitor nunc vel luctus. Nam varius, est eget iaculis accumsan, nunc ex blandit augue, vel semper ex metus non erat. Maecenas dictum condimentum ipsum. Praesent pharetra elit sed rutrum dignissim. Nunc interdum odio at mi volutpat, ut accumsan nulla consequat. Nullam ac tincidunt eros, vel sodales libero. Duis scelerisque varius interdum. Donec vitae tincidunt lacus, sit amet varius purus. Aenean scelerisque ex eu diam bibendum, rutrum posuere nulla placerat.",
                dateTime: Date(),
                expectedHours: 5,
                location: "Your moms house",
                payment: 69420,
                helper: jobHelper
        ))
        
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        currentJobsTableView.delegate = self
        currentJobsTableView.dataSource = self
        
        self.setupNavBar()
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: - UI Setup
    private func setupNavBar() {
        self.navigationController?.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .semibold)]
        self.navigationItem.title = "Current Jobs"
    }
    
        
    private func setupUI() {
        self.view.addSubview(currentJobsTableView)
        currentJobsTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            currentJobsTableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
            currentJobsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            currentJobsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            currentJobsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    
    // MARK: - Selectors & Functions
    
}

// MARK: - Search Bar Delegate
extension CurrentJobsController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection selection: Int) -> Int {
        return self.currentJobs.allJobs.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrentJobsCell.identifier, for: indexPath) as? CurrentJobsCell else {
            fatalError("The SearchTableView could not dequeue a SearchTableCell in HomeController.")
        }
        
        let currentJob = self.currentJobs.allJobs[indexPath.row]

        cell.configureCell(for: currentJob)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let jobInfoController = JobInfoController(for: self.currentJobs.allJobs[indexPath.row])
        
        jobInfoController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(jobInfoController, animated: true)
    }
}
