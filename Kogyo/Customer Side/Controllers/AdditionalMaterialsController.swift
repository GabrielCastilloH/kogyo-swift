//
//  AdditionalMaterialsController.swift
//  Kogyo
//
//  Created by Gabriel Castillo on 8/10/24.
//

import UIKit

protocol AdditionalMaterialsDelegate {
    func didEnterMaterial(_ data: (String, Int, Float))
}

class AdditionalMaterialsController: UIViewController {
    
    private let materials = AppBasicData.shared.materials
    private let tableView = UITableView()
    private let searchBar = UISearchBar()
    private var filteredMaterials: [Material] = []
    private var selectedMaterial: Material?
    
    var delegate: AdditionalMaterialsDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.filteredMaterials = self.materials
        
        setupSearchBar()
        setupTableView()
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search Materials"
        searchBar.sizeToFit()
        searchBar.backgroundColor = .white
        
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MaterialsCell.self, forCellReuseIdentifier: "MaterialsCell")
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func filterMaterials(for searchText: String) {
        if searchText.isEmpty {
            filteredMaterials = materials
        } else {
            filteredMaterials = materials.filter { material in
                material.name.lowercased().contains(searchText.lowercased())
            }
        }
        tableView.reloadData()
    }
}

extension AdditionalMaterialsController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Set(filteredMaterials.map { $0.category }).count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let category = getCategory(for: section)
        return filteredMaterials.filter { $0.category == category }.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MaterialsCell", for: indexPath) as! MaterialsCell
        let category = getCategory(for: indexPath.section)
        let material = filteredMaterials.filter { $0.category == category }[indexPath.row]
        cell.configure(with: material)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return getCategory(for: section)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = getCategory(for: indexPath.section)
        let material = filteredMaterials.filter { $0.category == category }[indexPath.row]
        selectedMaterial = material
        promptForQuantity()
    }
    
    private func getCategory(for section: Int) -> String {
        let categories = Array(Set(filteredMaterials.map { $0.category })).sorted()
        return categories[section]
    }
    
    private func promptForQuantity() {
        guard let material = selectedMaterial else { return }
        
        let alert = UIAlertController(title: "Enter Quantity", message: "How many \(material.name) are required?", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.keyboardType = .numberPad
        }
        let doneAction = UIAlertAction(title: "Done", style: .default) { [weak self] _ in
            if let quantityText = alert.textFields?.first?.text, let quantity = Int(quantityText) {
                self?.materialSelected(name: material.name, quantity: quantity, price: material.price)
            }
        }
        alert.addAction(doneAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func materialSelected(name: String, quantity: Int, price: Float) {
        self.delegate?.didEnterMaterial((name, quantity, price))
    }
}

extension AdditionalMaterialsController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterMaterials(for: searchText)
    }
}
