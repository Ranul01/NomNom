//
//  Models.swift
//  Nom Nom
//
//  Created by Ranul Thilakarathna on 2025-04-18.
//

//import Foundation
//
//// Model for a receipt item
//struct ReceiptItem: Identifiable, Codable {
//    var id = UUID()
//    var name: String
//    var amount: Double
//}
//
//// Model for a receipt category
//struct ReceiptCategory: Identifiable, Codable {
//    var id = UUID()
//    var name: String
//    var items: [ReceiptItem]
//    var color: String // Store a color name that we'll convert to Color in the view
//    
//    var total: Double {
//        items.reduce(0) { $0 + $1.amount }
//    }
//}
//
//// Data store for the app
//class ReceiptStore: ObservableObject {
//    @Published var categories: [ReceiptCategory] = []
//    
//    private static func fileURL() -> URL? {
//        do {
//            return try FileManager.default.url(for: .documentDirectory,
//                                         in: .userDomainMask,
//                                         appropriateFor: nil,
//                                         create: true)
//                .appendingPathComponent("receipts.data")
//        } catch {
//            print("Error getting file URL: \(error)")
//            return nil
//        }
//    }
//    
//    // Load data from file
//    func load() {
//        DispatchQueue.global(qos: .background).async { [weak self] in
//            guard let self = self else { return }
//            guard let url = Self.fileURL() else { return }
//            
//            do {
//                let data = try Data(contentsOf: url)
//                if let decodedCategories = try? JSONDecoder().decode([ReceiptCategory].self, from: data) {
//                    DispatchQueue.main.async {
//                        self.categories = decodedCategories
//                    }
//                }
//            } catch {
//                print("Error loading data: \(error)")
//            }
//        }
//    }
//    
//    // Save data to file
//    func save() {
//        DispatchQueue.global(qos: .background).async { [weak self] in
//            guard let self = self else { return }
//            guard let url = Self.fileURL() else { return }
//            
//            do {
//                let data = try JSONEncoder().encode(self.categories)
//                try data.write(to: url)
//            } catch {
//                print("Error saving data: \(error)")
//            }
//        }
//    }
//    
//    // Add a new category
//    func addCategory(name: String, color: String) {
//        let newCategory = ReceiptCategory(name: name, items: [], color: color)
//        categories.append(newCategory)
//        save()
//    }
//    
//    // Add an item to a category
//    func addItem(to categoryIndex: Int, name: String, amount: Double) {
//        guard categoryIndex < categories.count else { return }
//        
//        let newItem = ReceiptItem(name: name, amount: amount)
//        categories[categoryIndex].items.append(newItem)
//        save()
//    }
//    
//    // Remove an item
//    func removeItem(from categoryIndex: Int, at indexSet: IndexSet) {
//        guard categoryIndex < categories.count else { return }
//        
//        categories[categoryIndex].items.remove(atOffsets: indexSet)
//        save()
//    }
//    
//    // Remove a category
//    func removeCategory(at indexSet: IndexSet) {
//        categories.remove(atOffsets: indexSet)
//        save()
//    }
//}
import Foundation

// Model for a receipt item
struct ReceiptItem: Identifiable, Codable {
    var id = UUID()
    var name: String
    var amount: Double
}

// Model for a receipt category
struct ReceiptCategory: Identifiable, Codable {
    var id = UUID()
    var name: String
    var items: [ReceiptItem]
    var color: String // Store a color name that we'll convert to Color in the view
    
    var total: Double {
        items.reduce(0) { $0 + $1.amount }
    }
}

// Data store for the app
class ReceiptStore: ObservableObject {
    @Published var categories: [ReceiptCategory] = []
    
    private static func fileURL() -> URL? {
        do {
            return try FileManager.default.url(for: .documentDirectory,
                                         in: .userDomainMask,
                                         appropriateFor: nil,
                                         create: true)
                .appendingPathComponent("receipts.data")
        } catch {
            print("Error getting file URL: \(error)")
            return nil
        }
    }
    
    // Load data from file
    func load() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            guard let url = Self.fileURL() else { return }
            
            do {
                let data = try Data(contentsOf: url)
                if let decodedCategories = try? JSONDecoder().decode([ReceiptCategory].self, from: data) {
                    DispatchQueue.main.async {
                        self.categories = decodedCategories
                    }
                }
            } catch {
                print("Error loading data: \(error)")
            }
        }
    }
    
    // Save data to file
    func save() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            guard let url = Self.fileURL() else { return }
            
            do {
                let data = try JSONEncoder().encode(self.categories)
                try data.write(to: url)
            } catch {
                print("Error saving data: \(error)")
            }
        }
    }
    
    // Add a new category
    func addCategory(name: String, color: String) {
        let newCategory = ReceiptCategory(name: name, items: [], color: color)
        categories.append(newCategory)
        save()
    }
    
    // Update an existing category
    func updateCategory(at index: Int, name: String, color: String, items: [ReceiptItem]) {
        guard index < categories.count else { return }
        
        categories[index].name = name
        categories[index].color = color
        categories[index].items = items
        save()
    }
    
    // Add an item to a category
    func addItem(to categoryIndex: Int, name: String, amount: Double) {
        guard categoryIndex < categories.count else { return }
        
        let newItem = ReceiptItem(name: name, amount: amount)
        categories[categoryIndex].items.append(newItem)
        save()
    }
    
    // Remove an item
    func removeItem(from categoryIndex: Int, at indexSet: IndexSet) {
        guard categoryIndex < categories.count else { return }
        
        categories[categoryIndex].items.remove(atOffsets: indexSet)
        save()
    }
    
    // Remove a category
    func removeCategory(at indexSet: IndexSet) {
        categories.remove(atOffsets: indexSet)
        save()
    }
}
