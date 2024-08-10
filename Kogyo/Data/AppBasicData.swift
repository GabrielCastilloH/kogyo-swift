//
//  JobListing.swift
//  App1
//
//  Created by Gabriel Castillo on 6/9/24.
//

import Foundation

// Model to represent Material
struct Material {
    let name: String
    let price: Float
    let category: String
}

class AppBasicData {
    
    public static let shared = AppBasicData()
    
    let allCategories = [
        JobCategoryView(title: "Home", jobButtons: [
            TaskCategoryBtnView(title: "Minor Repairs"),
            TaskCategoryBtnView(title: "Cleaning"),
            TaskCategoryBtnView(title: "Painting"),
        ]),
        JobCategoryView(title: "Personal", jobButtons: [
            TaskCategoryBtnView(title: "Baby Sitting"),
            TaskCategoryBtnView(title: "Dog Walking"),
            TaskCategoryBtnView(title: "Massages"),
        ]),
        JobCategoryView(title: "Technology", jobButtons: [
            TaskCategoryBtnView(title: "IT Support"),
            TaskCategoryBtnView(title: "Electrical Work"),
            TaskCategoryBtnView(title: "Wi-Fi Help"),
        ]),
        JobCategoryView(title: "Technology", jobButtons: [
            TaskCategoryBtnView(title: "IT Support"),
            TaskCategoryBtnView(title: "Electrical Work"),
            TaskCategoryBtnView(title: "Wi-Fi Help"),
        ]),
        JobCategoryView(title: "Technology", jobButtons: [
            TaskCategoryBtnView(title: "IT Support"),
            TaskCategoryBtnView(title: "Electrical Work"),
            TaskCategoryBtnView(title: "Wi-Fi Help"),
        ]),
    ]
    
    var allJobs: [TaskCategoryBtnView] {
        // Fetching all the jobs
        var jobs: [TaskCategoryBtnView] = []
        for category in allCategories {
            for job in category.jobs {
                jobs.append(job)
            }
        }
        return jobs
    }

    // Extended list of materials
    let materials: [Material] = [
        // Home - Minor Repairs
        Material(name: "Drywall Patch Kit", price: 8.0, category: "Home - Minor Repairs"),
        Material(name: "Wood Filler", price: 6.0, category: "Home - Minor Repairs"),
        Material(name: "Screws (Pack of 100)", price: 9.0, category: "Home - Minor Repairs"),
        Material(name: "Picture Hangers (Pack of 20)", price: 4.0, category: "Home - Minor Repairs"),
        Material(name: "Electrical Outlet Covers (Pack of 10)", price: 5.0, category: "Home - Minor Repairs"),
        
        // Home - Cleaning
        Material(name: "All-Purpose Cleaner (32 oz)", price: 6.0, category: "Home - Cleaning"),
        Material(name: "Microfiber Cloths (Pack of 6)", price: 10.0, category: "Home - Cleaning"),
        Material(name: "Vacuum Bags (Pack of 5)", price: 12.0, category: "Home - Cleaning"),
        Material(name: "Glass Cleaner (32 oz)", price: 4.0, category: "Home - Cleaning"),
        Material(name: "Sponges (Pack of 10)", price: 5.0, category: "Home - Cleaning"),
        
        // Home - Painting
        Material(name: "Paint Primer (1 gal)", price: 20.0, category: "Home - Painting"),
        Material(name: "Paint Brushes (Set of 3)", price: 12.0, category: "Home - Painting"),
        Material(name: "Painter's Tape (60 yd)", price: 6.0, category: "Home - Painting"),
        Material(name: "Drop Cloth (9x12 ft)", price: 10.0, category: "Home - Painting"),
        Material(name: "Paint Tray and Liners", price: 8.0, category: "Home - Painting"),
        
        // Personal - Baby Sitting
        Material(name: "Baby Monitor", price: 50.0, category: "Personal - Baby Sitting"),
        Material(name: "Baby Wipes (Pack of 100)", price: 6.0, category: "Personal - Baby Sitting"),
        Material(name: "Diapers (Pack of 30)", price: 15.0, category: "Personal - Baby Sitting"),
        Material(name: "Baby Bottle Sterilizer", price: 25.0, category: "Personal - Baby Sitting"),
        Material(name: "Infant Tylenol (4 oz)", price: 8.0, category: "Personal - Baby Sitting"),
        
        // Personal - Dog Walking
        Material(name: "Dog Leash", price: 10.0, category: "Personal - Dog Walking"),
        Material(name: "Dog Waste Bags (Roll of 100)", price: 5.0, category: "Personal - Dog Walking"),
        Material(name: "Dog Treats (Pack of 30)", price: 8.0, category: "Personal - Dog Walking"),
        Material(name: "Portable Water Bottle for Dogs", price: 12.0, category: "Personal - Dog Walking"),
        Material(name: "Dog Harness", price: 15.0, category: "Personal - Dog Walking"),
        
        // Personal - Massages
        Material(name: "Massage Oil (8 oz)", price: 12.0, category: "Personal - Massages"),
        Material(name: "Massage Table", price: 100.0, category: "Personal - Massages"),
        Material(name: "Aromatherapy Diffuser", price: 25.0, category: "Personal - Massages"),
        Material(name: "Hot Stones (Set of 10)", price: 20.0, category: "Personal - Massages"),
        Material(name: "Comfortable Pillows (Set of 2)", price: 20.0, category: "Personal - Massages"),
        
        // Technology - IT Support
        Material(name: "Ethernet Cables (Pack of 5)", price: 15.0, category: "Technology - IT Support"),
        Material(name: "USB Flash Drives (16 GB)", price: 8.0, category: "Technology - IT Support"),
        Material(name: "External Hard Drive (1 TB)", price: 60.0, category: "Technology - IT Support"),
        Material(name: "Computer Cleaning Kit", price: 12.0, category: "Technology - IT Support"),
        Material(name: "Power Surge Protector", price: 20.0, category: "Technology - IT Support"),
        
        // Technology - Electrical Work
        Material(name: "Electrical Wire (100 ft)", price: 25.0, category: "Technology - Electrical Work"),
        Material(name: "Wire Connectors (Pack of 50)", price: 7.0, category: "Technology - Electrical Work"),
        Material(name: "Circuit Tester", price: 15.0, category: "Technology - Electrical Work"),
        Material(name: "Electrical Tape (Pack of 3)", price: 4.0, category: "Technology - Electrical Work"),
        Material(name: "Light Switch Covers (Pack of 10)", price: 6.0, category: "Technology - Electrical Work"),
        
        // Technology - Wi-Fi Help
        Material(name: "Wi-Fi Router", price: 50.0, category: "Technology - Wi-Fi Help"),
        Material(name: "Wi-Fi Range Extender", price: 30.0, category: "Technology - Wi-Fi Help"),
        Material(name: "Network Cable Tester", price: 25.0, category: "Technology - Wi-Fi Help"),
        Material(name: "Ethernet Wall Jacks (Pack of 5)", price: 12.0, category: "Technology - Wi-Fi Help"),
        Material(name: "Modem", price: 40.0, category: "Technology - Wi-Fi Help"),
        
        // Additional Categories
        Material(name: "Safety Glasses", price: 5.0, category: "Miscellaneous"),
        Material(name: "Work Gloves (Pair)", price: 8.0, category: "Miscellaneous"),
        Material(name: "Measuring Tape (25 ft)", price: 10.0, category: "Miscellaneous"),
        Material(name: "Tool Belt", price: 15.0, category: "Miscellaneous"),
        Material(name: "Hammer", price: 12.0, category: "Miscellaneous"),
        Material(name: "Screwdriver Set", price: 18.0, category: "Miscellaneous"),
        Material(name: "Utility Knife", price: 7.0, category: "Miscellaneous"),
        Material(name: "Chisel Set", price: 20.0, category: "Miscellaneous"),
        Material(name: "Pliers Set", price: 12.0, category: "Miscellaneous"),
        Material(name: "Level", price: 10.0, category: "Miscellaneous")
    ]
}
