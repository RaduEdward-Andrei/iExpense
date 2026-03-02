---

# iExpense

A SwiftUI-based expense tracking application with local data persistence, multi-currency support, and structured expense grouping.

---

## Overview

**iExpense** allows users to:

* Create and categorize expenses (Personal / Business)
* Select currency per expense
* Persist data locally between app launches
* Delete expenses via swipe gestures
* View amounts styled dynamically based on value thresholds
* See expenses grouped into logical sections

The project demonstrates state-driven UI updates and safe list manipulation across filtered sections.

---

## Features

### Expense Management

* Add new expenses with name, type, amount, and currency
* Delete expenses using native swipe-to-delete gestures
* Group expenses into Personal and Business sections

### Persistence

* Local data storage using JSON encoding
* Automatic saving when data changes
* Data restored on app launch

### Multi-Currency Support

* Currency picker using ISO currency codes
* Locale-aware currency formatting
* Per-expense currency handling

### Conditional Styling

* Expense amounts styled based on value:

  * Low (< 10)
  * Medium (< 100)
  * High (≥ 100)
* Reusable custom `ViewModifier` for amount styling

---

## Screenshots

<p align="center">
  <img src="Screenshots/main-screen.png" width="300" />
  <img src="Screenshots/add-expense.png" width="300" />
</p>

---

## Demo

Short demo video:

[Watch the demo on LinkedIn]()

---

## Technologies

* Swift
* SwiftUI
* Observation (`@Observable`)
* JSON encoding/decoding
* Local persistence via `UserDefaults`

---

## Architecture Highlights

* Single source of truth (`Expenses` observable model)
* Section-based filtering with safe ID-mapped deletion
* Reusable row builder
* Reusable `ViewModifier` for styling logic
* Clear separation between model, persistence, and UI

---

## Learning Context

Built as part of **Hacking with Swift – SwiftUI (Project 7)**. https://www.hackingwithswift.com/books/ios-swiftui
Extended with:

* Multi-currency support
* Section-based grouping
* Safe deletion handling
* Conditional UI styling
* Reusable view abstractions

---
