import Foundation
import SwiftUI

class HistoryViewModel: ObservableObject {
    @Published var selectedPeriod: FilterPeriod = .thirtyDays
    @Published var minAmount: Int = 0
    @Published var maxAmount: Int = 0
    @Published var startDate = Date()
    @Published var endDate = Date()
    @Published var showingDateRange = false
    
    private let dataManager = DataManager.shared
    
    var filteredEntries: [SavingsEntry] {
        var entries = dataManager.savingsEntries
        
        let calendar = Calendar.current
        let now = Date()
        
        switch selectedPeriod {
        case .sevenDays:
            let sevenDaysAgo = calendar.date(byAdding: .day, value: -7, to: now) ?? now
            entries = entries.filter { $0.date >= sevenDaysAgo }
        case .thirtyDays:
            let thirtyDaysAgo = calendar.date(byAdding: .day, value: -30, to: now) ?? now
            entries = entries.filter { $0.date >= thirtyDaysAgo }
        case .dateRange:
            entries = entries.filter { $0.date >= startDate && $0.date <= endDate }
        }
        
        if minAmount > 0 {
            let minDollar = Double(minAmount) / 100.0
            entries = entries.filter { $0.amount >= minDollar }
        }
        
        if maxAmount > 0 {
            let maxDollar = Double(maxAmount) / 100.0
            entries = entries.filter { $0.amount <= maxDollar }
        }
        
        return entries
    }
    
    func resetFilters() {
        selectedPeriod = .thirtyDays
        minAmount = 0
        maxAmount = 0
        startDate = Date()
        endDate = Date()
    }
    
    func updateMinAmount(from text: String) {
        let filtered = text.filter { $0.isNumber || $0 == "." }
        if let dollars = Double(filtered) {
            minAmount = Int(dollars * 100)
        } else {
            minAmount = 0
        }
    }
    
    func updateMaxAmount(from text: String) {
        let filtered = text.filter { $0.isNumber || $0 == "." }
        if let dollars = Double(filtered) {
            maxAmount = Int(dollars * 100)
        } else {
            maxAmount = 0
        }
    }
    
    func formatMinAmountForDisplay() -> String {
        guard minAmount > 0 else { return "" }
        let dollars = minAmount / 100
        let cents = minAmount % 100
        return String(format: "%d.%02d", dollars, cents)
    }
    
    func formatMaxAmountForDisplay() -> String {
        guard maxAmount > 0 else { return "" }
        let dollars = maxAmount / 100
        let cents = maxAmount % 100
        return String(format: "%d.%02d", dollars, cents)
    }
}

enum FilterPeriod: String, CaseIterable {
    case sevenDays = "7 Days"
    case thirtyDays = "30 Days"
    case dateRange = "Date Range"
}
