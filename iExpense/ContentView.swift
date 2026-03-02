//
//  ContentView.swift
//  iExpense
//
//  Created by Radu Edward-Andrei on 24.02.2026.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
    var currency: String
}

@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet {
            if let encoded =  try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        guard let savedItems = UserDefaults.standard.data(forKey: "Items") else {
            items = []
            return
        }
        
        do {
            items = try JSONDecoder().decode([ExpenseItem].self, from: savedItems)
        } catch {
            items = []
        }
    }
}

struct ContentView: View {
    @State private var expenses = Expenses()
    
    @State private var showingAddExpense = false
    
    private var personalExpenses: [ExpenseItem] {
        expenses.items.filter { $0.type == "Personal" }
    }
    
    private var businessExpenses: [ExpenseItem] {
        expenses.items.filter { $0.type == "Business" }
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section("Personal") {
                    ForEach(personalExpenses) { item in
                        expenseRow(for: item)
                    }
                    .onDelete { offsets in
                        deleteItems(in: personalExpenses, at: offsets)
                    }
                }
                
                Section("Business") {
                    ForEach(businessExpenses) { item in
                        expenseRow(for: item)
                    }
                    .onDelete { offsets in
                        deleteItems(in: businessExpenses, at: offsets)
                    }
                }
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button("Add expense", systemImage: "plus") {
                    showingAddExpense = true
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddExpense(expenses: expenses)
            }
        }
    }
    
    private func deleteItems(in sectionItems: [ExpenseItem], at offsets: IndexSet) {
        let idsToDelete = offsets.map { sectionItems[$0].id }
        expenses.items.removeAll { idsToDelete.contains($0.id) }
    }
    
    @ViewBuilder
    private func expenseRow(for item: ExpenseItem) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.headline)
                
                Text(item.type)
            }
            
            Spacer()
            
            Text(
                item.amount,
                format: .currency(code: item.currency)
            )
            .expenseAmountStyle(for: item.amount)
        }
    }
}

struct ExpenseAmountStyle: ViewModifier {
    let amount: Double
    
    private var textColor: Color {
        switch amount {
            case ..<10:  return .teal
            case ..<100: return .orange
            default:     return .red
        }
    }
    
    private var fontWeight: Font.Weight {
        switch amount {
            case ..<10:  return .regular
            case ..<100: return .semibold
            default:     return .bold
        }
    }
    
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .foregroundStyle(textColor)
            .fontWeight(fontWeight)
            .background(textColor.opacity(0.15), in: Capsule())
    }
}

extension View {
    func expenseAmountStyle(for amount: Double) -> some View {
        modifier(ExpenseAmountStyle(amount: amount))
    }
}

#Preview {
    ContentView()
}
