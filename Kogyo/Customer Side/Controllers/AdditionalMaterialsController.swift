//
//  AdditionalMaterialsController.swift
//  Kogyo
//
//  Created by Gabriel Castillo on 8/10/24.
//

import UIKit

// Model to represent Material
struct Material {
    let name: String
    let price: Float
    let category: String
}

class AdditionalMaterialsController: UIViewController {
    
    private let materials: [Material] = [
        Material(name: "Paint", price: 25.0, category: "Construction"),
        Material(name: "Nails", price: 10.0, category: "Construction"),
        Material(name: "Soil", price: 15.0, category: "Care"),
        Material(name: "Fertilizer", price: 30.0, category: "Care")
    ]
    
    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    private var filteredMaterials: [Material] = []
    private var selectedMaterial: Material?
    
    override func viewDidLoad() {
        self.filteredMaterials = self.materials
        
        super.viewDidLoad()
        print("this view did load.")
        self.setupTableView()
//        self.setupSearchController()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MaterialsCell.self, forCellReuseIdentifier: "MaterialsCell")
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Materials"
        navigationItem.searchController = searchController
        definesPresentationContext = true
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
        let categories = Set(filteredMaterials.map { $0.category })
        return Array(categories)[section]
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
        print("Material Selected: \(name), Quantity: \(quantity), Price: \(price)")
    }
}

extension AdditionalMaterialsController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        filterMaterials(for: searchText)
    }
}
