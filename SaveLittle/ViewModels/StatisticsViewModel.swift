import Foundation
import SwiftUI

class StatisticsViewModel: ObservableObject {
    @Published var selectedPeriod: StatisticsPeriod = .thirtyDays
    @Published var startDate = Date()
    @Published var endDate = Date()
    
    private let dataManager = DataManager.shared
    
    var periodEntries: [SavingsEntry] {
        let calendar = Calendar.current
        let now = Date()
        
        switch selectedPeriod {
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
    
    var daysWithEntries: Int {
        let calendar = Calendar.current
        let uniqueDays = Set(periodEntries.map { calendar.startOfDay(for: $0.date) })
        return uniqueDays.count
    }
    
    var daysMissed: Int {
        let calendar = Calendar.current
        let totalDays = calendar.dateComponents([.day], from: periodStartDate, to: Date()).day ?? 0
        return max(0, totalDays - daysWithEntries)
    }
    
    var averageAmountOnCompletedDays: Double {
        guard daysWithEntries > 0 else { return 0 }
        let total = periodEntries.reduce(0) { $0 + $1.amount }
        return total / Double(daysWithEntries)
    }
    
    var formattedAverageAmount: String {
        return String(format: "$%.2f", averageAmountOnCompletedDays)
    }
    
    var longestCompletionStreak: Int {
        return calculateLongestStreak(forCompletion: true)
    }
    
    var longestMissedStreak: Int {
        return calculateLongestStreak(forCompletion: false)
    }
    
    var weeklyComparison: [WeeklyStats] {
        let calendar = Calendar.current
        var weeks: [WeeklyStats] = []
        
        var currentDate = periodStartDate
        let endDate = Date()
        
        while currentDate <= endDate {
            let weekStart = calendar.dateInterval(of: .weekOfYear, for: currentDate)?.start ?? currentDate
            let weekEnd = calendar.dateInterval(of: .weekOfYear, for: currentDate)?.end ?? currentDate
            
            let weekEntries = periodEntries.filter { entry in
                entry.date >= weekStart && entry.date < weekEnd
            }
            
            let daysInWeek = calendar.dateComponents([.day], from: weekStart, to: min(weekEnd, endDate)).day ?? 7
            let completedDays = Set(weekEntries.map { calendar.startOfDay(for: $0.date) }).count
            let completionPercentage = Double(completedDays) / Double(daysInWeek) * 100
            
            let totalAmount = weekEntries.reduce(0) { $0 + $1.amount }
            let averageAmount = totalAmount / Double(daysInWeek)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM dd"
            let weekLabel = "\(formatter.string(from: weekStart)) - \(formatter.string(from: weekEnd))"
            
            weeks.append(WeeklyStats(
                weekLabel: weekLabel,
                completionPercentage: completionPercentage,
                averageAmount: averageAmount
            ))
            
            currentDate = calendar.date(byAdding: .weekOfYear, value: 1, to: currentDate) ?? currentDate
        }
        
        return weeks
    }
    
    private var periodStartDate: Date {
        let calendar = Calendar.current
        let now = Date()
        
        switch selectedPeriod {
        case .thirtyDays:
            return calendar.date(byAdding: .day, value: -30, to: now) ?? now
        case .ninetyDays:
            return calendar.date(byAdding: .day, value: -90, to: now) ?? now
        case .dateRange:
            return startDate
        }
    }
    
    private func calculateLongestStreak(forCompletion: Bool) -> Int {
        let calendar = Calendar.current
        let allDays = generateDateRange(from: periodStartDate, to: Date())
        
        var currentStreak = 0
        var longestStreak = 0
        
        for day in allDays {
            let hasEntry = periodEntries.contains { calendar.isDate($0.date, inSameDayAs: day) }
            
            if hasEntry == forCompletion {
                currentStreak += 1
                longestStreak = max(longestStreak, currentStreak)
            } else {
                currentStreak = 0
            }
        }
        
        return longestStreak
    }
    
    private func generateDateRange(from startDate: Date, to endDate: Date) -> [Date] {
        var dates: [Date] = []
        let calendar = Calendar.current
        var currentDate = startDate
        
        while currentDate <= endDate {
            dates.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
        
        return dates
    }
}

enum StatisticsPeriod: String, CaseIterable {
    case thirtyDays = "30 Days"
    case ninetyDays = "90 Days"
    case dateRange = "Date Range"
}

struct WeeklyStats {
    let weekLabel: String
    let completionPercentage: Double
    let averageAmount: Double
    
    var formattedCompletionPercentage: String {
        return String(format: "%.1f%%", completionPercentage)
    }
    
    var formattedAverageAmount: String {
        return String(format: "$%.2f", averageAmount)
    }
}
