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
    
    let colors = ["red", "orange", "yellow", "green", "blue", "purple", "pink"]
    
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
            
            // Add Receipt Form
            VStack {
                Text("Add Receipt")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)
                
                // Type/Category Selection
                if showingCategoryInput {
                    // New category creation
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
                } else {
                    // Existing category selection
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
                
                // Add button
                Button(action: {
                    addItem()
                }) {
                    HStack {
                        Text("Add")
                        Image(systemName: "plus")
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 50)
                    .background(Color.purple.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(25)
                }
                .padding(.vertical)
                
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
                    
                    Button(action: {
                        // Update functionality would typically modify an existing receipt
                        // We'll just simulate a save for this example
                        saveReceipt()
                    }) {
                        Text("Update")
                            .padding(.vertical, 8)
                            .padding(.horizontal, 20)
                            .background(Color.orange.opacity(0.7))
                            .foregroundColor(.white)
                            .cornerRadius(15)
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
    
    // Save receipt to store
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
