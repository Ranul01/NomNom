//
//  ContentView.swift
//  Nom Nom
//
//  Created by Ranul Thilakarathna on 2025-04-18.
//

import SwiftUI

// Extension to convert string to Color
extension String {
    func toColor() -> Color {
        switch self.lowercased() {
        case "red": return .red
        case "orange": return .orange
        case "yellow": return .yellow
        case "green": return .green
        case "blue": return .blue
        case "purple": return .purple
        case "pink": return .pink
        default: return .gray
        }
    }
}

struct ContentView: View {
    // Use EnvironmentObject instead of StateObject
    @EnvironmentObject var receiptStore: ReceiptStore
    @State private var showingAddSheet = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    // Header
                    ZStack {
                        Color.purple.opacity(0.5)
                            .edgesIgnoringSafeArea(.top)
                        
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
                            
                            NavigationLink(destination: ProfileView()) {
                                Image(systemName: "person.circle")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(Color.purple.opacity(0.7))
                                    .clipShape(Circle())
                            }
                        }
                        .padding()
                    }
                    .frame(height: 150)
                    
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(0..<receiptStore.categories.count, id: \.self) { index in
                                CategoryCardView(category: $receiptStore.categories[index], categoryIndex: index, store: receiptStore)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                    }
                    
                    Spacer()
                    
                    // Add button
                    Button(action: {
                        showingAddSheet = true
                    }) {
                        HStack {
                            Text("Add")
                                .fontWeight(.semibold)
                            Image(systemName: "plus")
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 50)
                        .background(Color.purple.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(25)
                    }
                    .padding(.bottom, 20)
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                receiptStore.load()
            }
            .sheet(isPresented: $showingAddSheet) {
                AddReceiptView(receiptStore: receiptStore)
            }
        }
    }
}

struct CategoryCardView: View {
    @Binding var category: ReceiptCategory
    let categoryIndex: Int
    let store: ReceiptStore
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(category.name)
                .font(.headline)
                .fontWeight(.bold)
                .padding(.top, 10)
                .padding(.horizontal)
            
            ForEach(category.items) { item in
                HStack {
                    Text("•")
                    Text(item.name)
                    Spacer()
                    Text("Rs \(Int(item.amount))")
                }
                .padding(.horizontal)
            }
            
            HStack {
                Spacer()
                Text("Total Rs \(Int(category.total))")
                    .fontWeight(.semibold)
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
        }
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
        .overlay(
            Rectangle()
                .frame(width: 5)
                .foregroundColor(category.color.toColor())
                .cornerRadius(10)
                .clipped()
            , alignment: .leading
        )
    }
}

struct ProfileView: View {
    var body: some View {
        Text("Profile Page")
            .navigationTitle("Profile")
    }
}

// Preview provider needs to be updated to provide the environment object
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ReceiptStore())
    }
}
