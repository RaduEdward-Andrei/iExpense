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
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(expenses.items) { item in
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
                .onDelete(perform: removeItems)
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
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
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
