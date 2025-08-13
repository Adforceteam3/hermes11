import Foundation
import SwiftUI

struct WeeklyStatsData {
    let totalSaved: Double
    let daysCompleted: Int
    let daysElapsed: Int
    let averagePerDay: Double
    
    var formattedTotal: String {
        return String(format: "$%.2f", totalSaved)
    }
    
    var formattedAverage: String {
        return String(format: "$%.2f", averagePerDay)
    }
    
    var completionPercentage: Double {
        return Double(daysCompleted) / Double(daysElapsed)
    }
    
    var progressText: String {
        return "\(daysCompleted)/\(daysElapsed) days"
    }
}

class MainViewModel: ObservableObject {
    @Published var amount: Int = 0
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    private let dataManager = DataManager.shared
    
    var dailyPlannedAmount: Int {
        return Int(dataManager.dailyPlannedAmount * 100)
    }
    
    var formattedDailyAmount: String {
        return String(format: "$%.2f", Double(dailyPlannedAmount) / 100.0)
    }
    
    var formattedAmount: String {
        return String(format: "$%.2f", Double(amount) / 100.0)
    }
    
    var totalSaved: String {
        return dataManager.formattedTotalSaved
    }
    
    var hasEntryForToday: Bool {
        return dataManager.hasEntryForToday()
    }
    
    var currentGoal: Goal? {
        return dataManager.currentGoal
    }
    
    var goalProgress: Double {
        guard let goal = currentGoal else { return 0 }
        return goal.progress(currentAmount: dataManager.currentGoalSaved)
    }
    
    var remainingToGoal: String {
        guard let goal = currentGoal else { return "" }
        let remaining = goal.remainingAmount(currentAmount: dataManager.currentGoalSaved)
        return String(format: "$%.2f", remaining)
    }
    
    var currentGoalSaved: String {
        return dataManager.formattedCurrentGoalSaved
    }
    
    var isButtonEnabled: Bool {
        guard !hasEntryForToday else { return false }
        return amount >= 1
    }
    
    var weeklyStats: WeeklyStatsData {
        let calendar = Calendar.current
        let today = Date()
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: today)?.start ?? today
        
        let weekEntries = dataManager.savingsEntries.filter { entry in
            entry.date >= startOfWeek && entry.date <= today
        }
        
        let totalThisWeek = weekEntries.reduce(0) { $0 + $1.amount }
        let daysWithEntries = Set(weekEntries.map { calendar.startOfDay(for: $0.date) }).count
        let currentDayOfWeek = calendar.component(.weekday, from: today) - 1
        let daysElapsed = max(1, currentDayOfWeek + 1)
        
        return WeeklyStatsData(
            totalSaved: totalThisWeek,
            daysCompleted: daysWithEntries,
            daysElapsed: daysElapsed,
            averagePerDay: totalThisWeek / Double(daysElapsed)
        )
    }
    
    var isGoalAchieved: Bool {
        return dataManager.isCurrentGoalAchieved()
    }
    
    init() {
        amount = dailyPlannedAmount
    }
    
    func saveToday() {
        guard !hasEntryForToday else {
            alertMessage = "Today's entry already saved"
            showAlert = true
            return
        }
        
        guard amount >= 1 else {
            alertMessage = "Amount must be at least $0.01"
            showAlert = true
            return
        }
        
        let dollarAmount = Double(amount) / 100.0
        dataManager.addSavingsEntry(amount: dollarAmount)
        
        amount = dailyPlannedAmount
        
        alertMessage = "Successfully saved \(String(format: "$%.2f", dollarAmount))!"
        showAlert = true
    }
    
    func updateAmount(from text: String) {
        let filtered = text.filter { $0.isNumber || $0 == "." }
        
        if let dollars = Double(filtered) {
            let cents = Int(dollars * 100)
            amount = min(cents, 99999)
        } else {
            amount = 0
        }
    }
    
    func formatAmountForDisplay() -> String {
        let dollars = amount / 100
        let cents = amount % 100
        return String(format: "%d.%02d", dollars, cents)
    }
}
