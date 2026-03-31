//
//  ContentView.swift
//  iExpense
//
//  Created by Radu Edward-Andrei on 24.02.2026.
//

import SwiftData
import SwiftUI

enum SortOption: String, CaseIterable {
    case name = "Name"
    case amount = "Amount"
}

enum FilterOption: String, CaseIterable {
    case all = "All"
    case personal = "Personal"
    case business = "Business"
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var expenses: [ExpenseItem]
    
    
    @State private var sortOption: SortOption = .name
    @State private var filterOption: FilterOption = .all
    
    private var visibleExpenses: [ExpenseItem] {
        let filtered: [ExpenseItem]
        
        switch filterOption {
        case .all:
            filtered = expenses
        case .personal:
            filtered = expenses.filter { $0.type == "Personal" }
        case .business:
            filtered = expenses.filter { $0.type == "Business" }
        }
        
        switch sortOption {
        case .name:
            return filtered.sorted {
                $0.name.localizedCompare($1.name) == .orderedAscending
            }
        case .amount:
            return filtered.sorted { $0.amount < $1.amount }
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(visibleExpenses) { item in
                    NavigationLink {
                        EditExpense(expense: item)
                    } label: {
                        expenseRow(for: item)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("iExpense")
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    
                    Menu {
                        Section("Sort") {
                            Picker("Sort", selection: $sortOption) {
                                ForEach(SortOption.allCases, id: \.self) { option in
                                    Text(option.rawValue)
                                }
                            }
                        }
                        
                        Section("Filter") {
                            Picker("Filter", selection: $filterOption) {
                                ForEach(FilterOption.allCases, id: \.self) { option in
                                    Text(option.rawValue)
                                }
                            }
                        }
                        
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                    
                    NavigationLink {
                        AddExpense()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
    
    private func deleteItems(at offsets: IndexSet) {
        for offset in offsets {
            let item = visibleExpenses[offset]
            modelContext.delete(item)
        }
    }
    
    @ViewBuilder
    private func expenseRow(for item: ExpenseItem) -> some View {
        HStack(spacing: 12) {
            Image(systemName: item.type == "Business" ? "briefcase.fill" : "person.fill")
                .font(.subheadline)
                .foregroundStyle(item.type == "Business" ? .indigo : .blue)
                .frame(width: 28, height: 28)
                .background(.ultraThinMaterial, in: Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline)
                
                Text(item.type)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Text(
                item.amount,
                format: .currency(code: item.currency)
            )
            .expenseAmountStyle(for: item.amount)
        }
        .padding(.vertical, 4)
    }
}

struct ExpenseAmountStyle: ViewModifier {
    let amount: Double
    
    private var textColor: Color {
        switch amount {
            case ..<10:  return .primary.opacity(0.7)
            case ..<100: return .primary
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
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .foregroundStyle(textColor)
            .fontWeight(fontWeight)
            .background(.ultraThinMaterial, in: Capsule())
            .overlay(
                Capsule()
                    .stroke(Color.white.opacity(0.05))
            )
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
