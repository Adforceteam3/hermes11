import Foundation
import SwiftUI

class GoalViewModel: ObservableObject {
    @Published var goalName: String = ""
    @Published var goalAmount: Int = 0
    @Published var targetDate: Date = Date()
    @Published var hasTargetDate: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var showArchive: Bool = false
    
    private let dataManager = DataManager.shared
    
    var currentGoal: Goal? {
        return dataManager.currentGoal
    }
    
    var isButtonEnabled: Bool {
        return goalAmount > 0
    }
    
    var isGoalAchieved: Bool {
        return dataManager.isCurrentGoalAchieved()
    }
    
    var canCompleteGoal: Bool {
        return currentGoal != nil && isGoalAchieved
    }
    
    var hasActiveGoal: Bool {
        return currentGoal != nil
    }
    
    var completedGoals: [CompletedGoal] {
        return dataManager.completedGoals
    }
    
    var hasCompletedGoals: Bool {
        return !completedGoals.isEmpty
    }
    
    init() {
        loadCurrentGoal()
    }
    
    func loadCurrentGoal() {
        if let goal = currentGoal {
            goalName = goal.name ?? ""
            goalAmount = Int(goal.targetAmount * 100)
            if let date = goal.targetDate {
                targetDate = date
                hasTargetDate = true
            }
        }
    }
    
    func saveGoal() -> Bool {
        guard goalAmount > 0 else {
            alertMessage = "Please enter a valid goal amount"
            showAlert = true
            return false
        }
        
        let dollarAmount = Double(goalAmount) / 100.0
        let goal = Goal(
            name: goalName.isEmpty ? nil : goalName,
            targetAmount: dollarAmount,
            targetDate: hasTargetDate ? targetDate : nil,
            createdDate: Date()
        )
        
        dataManager.setGoal(goal)
        
        alertMessage = "Goal saved successfully!"
        showAlert = true
        return true
    }
    
    func updateAmount(from text: String) {
        let filtered = text.filter { $0.isNumber || $0 == "." }
        
        if let dollars = Double(filtered) {
            let cents = Int(dollars * 100)
            goalAmount = min(cents, 99999999)
        } else {
            goalAmount = 0
        }
    }
    
    func formatAmountForDisplay() -> String {
        let dollars = goalAmount / 100
        let cents = goalAmount % 100
        return String(format: "%d.%02d", dollars, cents)
    }
    
    func completeCurrentGoal() {
        dataManager.completeCurrentGoal()
        resetForm()
        
        alertMessage = "Congratulations! Goal completed successfully! 🎉"
        showAlert = true
    }
    
    func clearCurrentGoal() {
        dataManager.clearCurrentGoal()
        resetForm()
        
        alertMessage = "Goal cleared successfully!"
        showAlert = true
    }
    
    func resetForm() {
        goalName = ""
        goalAmount = 0
        hasTargetDate = false
        targetDate = Date()
    }
}
