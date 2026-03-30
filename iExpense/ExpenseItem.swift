//
//  ExpenseItem.swift
//  iExpense
//
//  Created by Radu Edward-Andrei on 30.03.2026.
//

import Foundation
import SwiftData

@Model
class ExpenseItem {
    var name: String
    var type: String
    var amount: Double
    var currency: String
    
    init(name: String, type: String, amount: Double, currency: String) {
        self.name = name
        self.type = type
        self.amount = amount
        self.currency = currency
    }
}
