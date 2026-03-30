//
//  iExpenseApp.swift
//  iExpense
//
//  Created by Radu Edward-Andrei on 24.02.2026.
//

import SwiftData
import SwiftUI

@main
struct iExpenseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: ExpenseItem.self)
    }
}
