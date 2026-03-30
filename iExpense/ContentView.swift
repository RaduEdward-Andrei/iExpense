//
//  ContentView.swift
//  iExpense
//
//  Created by Radu Edward-Andrei on 24.02.2026.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var expenses: [ExpenseItem]
    
    
    private var personalExpenses: [ExpenseItem] {
        expenses.filter { $0.type == "Personal" }
    }
    
    private var businessExpenses: [ExpenseItem] {
        expenses.filter { $0.type == "Business" }
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
                NavigationLink {
                    AddExpense()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
    
    private func deleteItems(in sectionItems: [ExpenseItem], at offsets: IndexSet) {
        for offset in offsets {
            let item = sectionItems[offset]
            modelContext.delete(item)
        }
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
        .modelContainer(for: ExpenseItem.self, inMemory: true)
}
