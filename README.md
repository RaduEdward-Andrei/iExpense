# iExpense

A SwiftUI-based expense tracking application featuring local persistence, multi-currency support, and structured expense grouping.

---

## Screenshots

<p align="center">
  <img src="Screenshots/main-screen.png" width="300" />
  <img src="Screenshots/add-expense.png" width="300" />
</p>

---

## Features

### Expense Management
- Add expenses with name, type, amount, and currency
- Delete expenses using native swipe gestures
- Group expenses into Personal and Business sections

### Persistence
- Local storage using JSON encoding
- Automatic save on data change
- Data restored on app launch

### Multi-Currency Support
- Currency picker using ISO currency codes
- Locale-aware currency formatting
- Per-expense currency handling

### Conditional Styling
- Amount styling based on value thresholds:
  - Low (< 10)
  - Medium (< 100)
  - High (≥ 100)
- Reusable `ViewModifier` for amount formatting

---

## Demo

Short demo video:

[Watch the demo on LinkedIn]()

---

## Technologies

- Swift
- SwiftUI
- Observation (`@Observable`)
- JSON encoding / decoding
- Local persistence via `UserDefaults`

---

## Learning Context

Built as part of **Hacking with Swift – SwiftUI (Project 7)**  
https://www.hackingwithswift.com/books/ios-swiftui

Extended beyond the base tutorial with:
- Multi-currency support
- Section-based grouping
- Safe deletion across filtered sections
- Conditional UI styling
- Reusable view abstractions
