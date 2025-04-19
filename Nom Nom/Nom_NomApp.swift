//
//  Nom_NomApp.swift
//  Nom Nom
//
//  Created by Ranul Thilakarathna on 2025-04-18.
//

import SwiftUI

@main
struct NomNomApp: App {
    // Create a shared instance of ReceiptStore that will be used across the app
    @StateObject private var receiptStore = ReceiptStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(receiptStore)
        }
    }
}
