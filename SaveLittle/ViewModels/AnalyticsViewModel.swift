import Foundation
import SwiftUI

class AnalyticsViewModel: ObservableObject {
    @Published var selectedPeriod: AnalyticsPeriod = .thirtyDays
    @Published var startDate = Date()
    @Published var endDate = Date()
    @Published var selectedCandleData: CandlestickData?
    
    private let dataManager = DataManager.shared
    
    var periodEntries: [SavingsEntry] {
        let calendar = Calendar.current
        let now = Date()
        
        switch selectedPeriod {
        case .sevenDays:
            let sevenDaysAgo = calendar.date(byAdding: .day, value: -7, to: now) ?? now
            return dataManager.savingsEntries.filter { $0.date >= sevenDaysAgo }
        case .thirtyDays:
            let thirtyDaysAgo = calendar.date(byAdding: .day, value: -30, to: now) ?? now
            return dataManager.savingsEntries.filter { $0.date >= thirtyDaysAgo }
        case .ninetyDays:
            let ninetyDaysAgo = calendar.date(byAdding: .day, value: -90, to: now) ?? now
            return dataManager.savingsEntries.filter { $0.date >= ninetyDaysAgo }
        case .dateRange:
            return dataManager.savingsEntries.filter { $0.date >= startDate && $0.date <= endDate }
        }
    }
    
    var totalSaved: Double {
        return periodEntries.reduce(0) { $0 + $1.amount }
    }
    
    var formattedTotalSaved: String {
        return String(format: "$%.2f", totalSaved)
    }
    
    var averageDailyAmount: Double {
        let calendar = Calendar.current
        let dayCount = calendar.dateComponents([.day], from: periodStartDate, to: Date()).day ?? 1
        return totalSaved / Double(max(1, dayCount))
    }
    
    var formattedAverageDailyAmount: String {
        return String(format: "$%.2f", averageDailyAmount)
    }
    
    var completionPercentage: Double {
        let calendar = Calendar.current
        let dayCount = calendar.dateComponents([.day], from: periodStartDate, to: Date()).day ?? 1
        let daysWithEntries = Set(periodEntries.map { calendar.startOfDay(for: $0.date) }).count
        return Double(daysWithEntries) / Double(max(1, dayCount)) * 100
    }
    
    var formattedCompletionPercentage: String {
        return String(format: "%.1f%%", completionPercentage)
    }
    
    var topDays: [SavingsEntry] {
        return periodEntries.sorted { $0.amount > $1.amount }.prefix(5).map { $0 }
    }
    
    var candlestickData: [CandlestickData] {
        let calendar = Calendar.current
        var data: [CandlestickData] = []
        
        var currentDate = periodStartDate
        let endDate = Date()
        
        var cumulativeAmount: Double = 0
        
        while currentDate <= endDate {
            let dayStart = calendar.startOfDay(for: currentDate)
            let dayEntries = periodEntries.filter { calendar.isDate($0.date, inSameDayAs: dayStart) }
            
            let open = cumulativeAmount
            let dayAmount = dayEntries.first?.amount ?? 0
            let close = cumulativeAmount + dayAmount
            
            let candlestick = CandlestickData(
                date: dayStart,
                open: open,
                high: max(open, close),
                low: min(open, close),
                close: close,
                entryAmount: dayAmount
            )
            
            data.append(candlestick)
            cumulativeAmount = close
            
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
        
        return data
    }
    
    private var periodStartDate: Date {
        let calendar = Calendar.current
        let now = Date()
        
        switch selectedPeriod {
        case .sevenDays:
            return calendar.date(byAdding: .day, value: -7, to: now) ?? now
        case .thirtyDays:
            return calendar.date(byAdding: .day, value: -30, to: now) ?? now
        case .ninetyDays:
            return calendar.date(byAdding: .day, value: -90, to: now) ?? now
        case .dateRange:
            return startDate
        }
    }
}

enum AnalyticsPeriod: String, CaseIterable {
    case sevenDays = "7 Days"
    case thirtyDays = "30 Days"
    case ninetyDays = "90 Days"
    case dateRange = "Date Range"
}

struct CandlestickData: Identifiable {
    let id = UUID()
    let date: Date
    let open: Double
    let high: Double
    let low: Double
    let close: Double
    let entryAmount: Double
    
    var isGreen: Bool {
        return close > open
    }
    
    var isFlat: Bool {
        return close == open
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter.string(from: date)
    }
    
    var status: SavingsStatus {
        if entryAmount > 0 {
            return .completed
        } else {
            return .missed
        }
    }
}
