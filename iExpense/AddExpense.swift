//
//  AddView.swift
//  iExpense
//
//  Created by Radu Edward-Andrei on 25.02.2026.
//

import SwiftUI

struct AddExpense: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    
    @State private var selectedCurrency = Locale.current.currency?.identifier ?? "RON"
    let currencies = Locale.commonISOCurrencyCodes.sorted()
    
    var expenses: Expenses
    
    let types = ["Business", "Personal"]
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                    .autocorrectionDisabled()   
                
                Picker("Type", selection: $type) {
                    ForEach(types, id:\.self) {
                        Text($0)
                            .tag($0)
                    }
                }
                
                Picker("Currency", selection: $selectedCurrency) {
                    ForEach(currencies, id: \.self) { code in
                        Text("\(code) – \(Locale.current.localizedString(forCurrencyCode: code) ?? code)")
                            .tag(code)
                    }
                }
                
                TextField(
                    "Amount",
                    value: $amount,
                    format: .currency(code: selectedCurrency)
                )
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Add new expense")
            .toolbar {
                Button("Save") {
                    let item = ExpenseItem(
                        name: name,
                        type: type,
                        amount: amount,
                        currency: selectedCurrency
                    )
                    expenses.items.append(item)
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    AddExpense(expenses: Expenses())
}
