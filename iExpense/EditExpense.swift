//
//  EditExpense.swift
//  iExpense
//
//  Created by Radu Edward-Andrei on 31.03.2026.
//

import SwiftUI
import SwiftData

struct EditExpense: View {
    @Environment(\.dismiss) private var dismiss
    
    var expense: ExpenseItem
    
    @State private var name: String
    @State private var type: String
    @State private var amount: Double
    @State private var currency: String
    
    let types = ["Business", "Personal"]
    let currencies = Locale.commonISOCurrencyCodes.sorted()
    
    init(expense: ExpenseItem) {
        self.expense = expense
        _name = State(initialValue: expense.name)
        _type = State(initialValue: expense.type)
        _amount = State(initialValue: expense.amount)
        _currency = State(initialValue: expense.currency)
    }
    
    var body: some View {
        Form {
            TextField("Name", text: $name)
                .autocorrectionDisabled()
            
            Picker("Type", selection: $type) {
                ForEach(types, id: \.self) {
                    Text($0)
                }
            }
            
            Picker("Currency", selection: $currency) {
                ForEach(currencies, id: \.self) { code in
                    Text("\(code) – \(Locale.current.localizedString(forCurrencyCode: code) ?? code)")
                        .tag(code)
                }
            }
            
            TextField(
                "Amount",
                value: $amount,
                format: .currency(code: currency)
            )
            .keyboardType(.decimalPad)
        }
        .navigationTitle("Edit expense")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    expense.name = name
                    expense.type = type
                    expense.amount = amount
                    expense.currency = currency
                    
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        EditExpense(
            expense: ExpenseItem(
                name: "Test",
                type: "Personal",
                amount: 25,
                currency: "RON"
            )
        )
    }
    .modelContainer(for: ExpenseItem.self, inMemory: true)
}
