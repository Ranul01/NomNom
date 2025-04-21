//
//  AddReceiptView.swift
//  Nom Nom
//
//  Created by Ranul Thilakarathna on 2025-04-18.
//

import SwiftUI

struct AddReceiptView: View {
    @ObservedObject var receiptStore: ReceiptStore
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    @State private var categoryName = ""
    @State private var itemName = ""
    @State private var amountText = ""
    @State private var selectedColor = "orange"
    @State private var items: [ReceiptItem] = []
    @State private var showingCategoryInput = false
    @State private var selectedCategoryIndex = 0
    @State private var editingItemIndex: Int? = nil
    @State private var isEditingItem = false
    
    // Update properties
    var isUpdating: Bool = false
    var categoryIndex: Int? = nil
    
    // Colors available for selection
    let colors = ["red", "orange", "yellow", "green", "blue", "purple", "pink"]
    
    // Initialize for creating a new receipt
    init(receiptStore: ReceiptStore, isUpdating: Bool = false) {
        self.receiptStore = receiptStore
        self.isUpdating = isUpdating
    }
    
    // Initialize for updating an existing receipt
    init(receiptStore: ReceiptStore, isUpdating: Bool, categoryIndex: Int, categoryName: String, selectedColor: String) {
        self.receiptStore = receiptStore
        self.isUpdating = isUpdating
        self._categoryName = State(initialValue: categoryName)
        self._selectedColor = State(initialValue: selectedColor)
        self.categoryIndex = categoryIndex
        self._selectedCategoryIndex = State(initialValue: categoryIndex)
        self._showingCategoryInput = State(initialValue: true)
        
        // Load existing items if updating
        if isUpdating && categoryIndex < receiptStore.categories.count {
            self._items = State(initialValue: receiptStore.categories[categoryIndex].items)
        }
    }
    
    var body: some View {
        VStack {
            // Header
            ZStack {
                Color.purple.opacity(0.5)
                    .frame(height: 150)
                
                HStack {
                    Image(systemName: "doc.text")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.purple.opacity(0.7))
                        .clipShape(Circle())
                    
                    Text("NomNom")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Image(systemName: "person.circle")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.purple.opacity(0.7))
                        .clipShape(Circle())
                }
                .padding()
            }
            
            // Add/Update Receipt Form
            VStack {
                Text(isUpdating ? "Update Receipt" : "Add Receipt")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)
                
                // Type/Category Selection
                if showingCategoryInput {
                    // New category creation or update existing
                    TextField("Type", text: $categoryName)
                        .padding()
                        .background(colorScheme == .dark ? Color(UIColor.darkGray) : Color(UIColor.systemBackground))
                        .foregroundColor(colorScheme == .dark ? .white : .primary)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .padding(.horizontal)
                    
                    // Color selector
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(colors, id: \.self) { color in
                                Circle()
                                    .fill(color.toColor())
                                    .frame(width: 30, height: 30)
                                    .overlay(
                                        Circle()
                                            .stroke(color == selectedColor ? Color.black : Color.clear, lineWidth: 2)
                                    )
                                    .onTapGesture {
                                        selectedColor = color
                                    }
                                    .padding(.horizontal, 5)
                            }
                        }
                        .padding(.horizontal)
                    }
                } else if !isUpdating {
                    // Existing category selection (only for new receipts)
                    if receiptStore.categories.isEmpty {
                        Button(action: {
                            showingCategoryInput = true
                        }) {
                            HStack {
                                Text("Create Category")
                                Image(systemName: "plus.circle")
                            }
                            .foregroundColor(.blue)
                            .padding()
                        }
                    } else {
                        Picker("Select Category", selection: $selectedCategoryIndex) {
                            ForEach(0..<receiptStore.categories.count, id: \.self) { index in
                                Text(receiptStore.categories[index].name).tag(index)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding()
                        .background(colorScheme == .dark ? Color(UIColor.darkGray) : Color.white)
                        .foregroundColor(colorScheme == .dark ? .white : .primary)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .padding(.horizontal)
                        
                        Button(action: {
                            showingCategoryInput = true
                        }) {
                            HStack {
                                Text("Or create new category")
                                Image(systemName: "plus.circle")
                            }
                            .foregroundColor(.blue)
                            .font(.caption)
                        }
                        .padding(.horizontal)
                    }
                }
                
                // Display existing items when updating
                if isUpdating && !items.isEmpty {
                    List {
                        ForEach(items.indices, id: \.self) { index in
                            HStack {
                                Text(items[index].name)
                                Spacer()
                                Text("Rs \(Int(items[index].amount))")
                                
                                // Edit button for each item
                                Button(action: {
                                    editingItemIndex = index
                                    itemName = items[index].name
                                    amountText = String(Int(items[index].amount))
                                    isEditingItem = true
                                }) {
                                    Image(systemName: "pencil")
                                        .foregroundColor(.blue)
                                }
                                .padding(.leading)
                            }
                        }
                        .onDelete { indexSet in
                            items.remove(atOffsets: indexSet)
                        }
                    }
                    .frame(height: min(CGFloat(items.count * 44), 200))
                    .cornerRadius(8)
                    .padding(.horizontal)
                }
                
                // Item name
                HStack {
                    Text("+")
                    TextField("Item", text: $itemName)
                }
                .padding()
                .background(colorScheme == .dark ? Color(UIColor.darkGray) : Color.white)
                .foregroundColor(colorScheme == .dark ? .white : .primary)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .padding(.horizontal)
                
                // Amount
                HStack {
                    Text("+")
                    TextField("Amount", text: $amountText)
                        .keyboardType(.numberPad)
                }
                .padding()
                .background(colorScheme == .dark ? Color(UIColor.darkGray) : Color.white)
                .foregroundColor(colorScheme == .dark ? .white : .primary)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .padding(.horizontal)
                
                // Add/Update Item button
                Button(action: {
                    if isEditingItem {
                        updateItem()
                    } else {
                        addItem()
                    }
                }) {
                    HStack {
                        Text(isEditingItem ? "Update Item" : "Add")
                        Image(systemName: isEditingItem ? "arrow.triangle.2.circlepath" : "plus")
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 50)
                    .background(isEditingItem ? Color.blue.opacity(0.7) : Color.purple.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(25)
                }
                .padding(.vertical)
                
                // Cancel edit button (shown only when editing an item)
                if isEditingItem {
                    Button(action: {
                        // Cancel editing and reset fields
                        isEditingItem = false
                        editingItemIndex = nil
                        itemName = ""
                        amountText = ""
                    }) {
                        Text("Cancel Edit")
                            .padding(.vertical, 8)
                            .padding(.horizontal, 20)
                            .background(Color.gray.opacity(0.7))
                            .foregroundColor(.white)
                            .cornerRadius(15)
                    }
                    .padding(.bottom, 8)
                }
                
                // Action buttons
                HStack(spacing: 20) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Cancel")
                            .padding(.vertical, 8)
                            .padding(.horizontal, 20)
                            .background(Color.purple.opacity(0.7))
                            .foregroundColor(.white)
                            .cornerRadius(15)
                    }
                    
                    if !isUpdating {
                        Button(action: {
                            saveReceipt()
                        }) {
                            Text("Save")
                                .padding(.vertical, 8)
                                .padding(.horizontal, 20)
                                .background(Color.red.opacity(0.7))
                                .foregroundColor(.white)
                                .cornerRadius(15)
                        }
                    } else {
                        Button(action: {
                            updateReceipt()
                        }) {
                            Text("Update")
                                .padding(.vertical, 8)
                                .padding(.horizontal, 20)
                                .background(Color.orange.opacity(0.7))
                                .foregroundColor(.white)
                                .cornerRadius(15)
                        }
                    }
                }
                .padding(.top)
                
                Spacer()
            }
            .background(colorScheme == .dark ? Color.black.opacity(0.6) : Color.gray.opacity(0.2))
            .cornerRadius(15)
            .padding()
        }
    }
    
    // Add item to temporary list
    private func addItem() {
        guard !itemName.isEmpty, let amount = Double(amountText), amount > 0 else { return }
        
        let newItem = ReceiptItem(name: itemName, amount: amount)
        items.append(newItem)
        
        // Clear fields
        itemName = ""
        amountText = ""
    }
    
    // Update an existing item
    private func updateItem() {
        guard !itemName.isEmpty,
              let amount = Double(amountText),
              amount > 0,
              let index = editingItemIndex,
              index < items.count else { return }
        
        // Update the item at the selected index
        items[index].name = itemName
        items[index].amount = amount
        
        // Reset editing state
        isEditingItem = false
        editingItemIndex = nil
        itemName = ""
        amountText = ""
    }
    
    // Save new receipt to store
    private func saveReceipt() {
        if showingCategoryInput && !categoryName.isEmpty {
            // Create new category
            receiptStore.addCategory(name: categoryName, color: selectedColor)
            
            // Add all items to the new category
            if !items.isEmpty {
                for item in items {
                    receiptStore.addItem(to: receiptStore.categories.count - 1,
                                         name: item.name,
                                         amount: item.amount)
                }
            } else if !itemName.isEmpty, let amount = Double(amountText), amount > 0 {
                // Add current item if there are no saved items
                receiptStore.addItem(to: receiptStore.categories.count - 1,
                                     name: itemName,
                                     amount: amount)
            }
        } else if !receiptStore.categories.isEmpty {
            // Add to existing category
            if !items.isEmpty {
                for item in items {
                    receiptStore.addItem(to: selectedCategoryIndex,
                                         name: item.name,
                                         amount: item.amount)
                }
            } else if !itemName.isEmpty, let amount = Double(amountText), amount > 0 {
                // Add current item if there are no saved items
                receiptStore.addItem(to: selectedCategoryIndex,
                                     name: itemName,
                                     amount: amount)
            }
        }
        
        // Dismiss the sheet
        presentationMode.wrappedValue.dismiss()
    }
    
    // Update existing receipt
    private func updateReceipt() {
        guard let index = categoryIndex else { return }
        
        // Update category name and color
        if !categoryName.isEmpty {
            receiptStore.updateCategory(at: index, name: categoryName, color: selectedColor, items: items)
        }
        
        // Add current item if it's being edited
        if !itemName.isEmpty, let amount = Double(amountText), amount > 0 {
            let newItem = ReceiptItem(name: itemName, amount: amount)
            receiptStore.addItem(to: index, name: newItem.name, amount: newItem.amount)
        }
        
        // Dismiss the sheet
        presentationMode.wrappedValue.dismiss()
    }
}

struct AddReceiptView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AddReceiptView(receiptStore: ReceiptStore())
                .preferredColorScheme(.light)
            
            AddReceiptView(receiptStore: ReceiptStore())
                .preferredColorScheme(.dark)
        }
    }
}
