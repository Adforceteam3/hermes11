import Foundation

struct Goal: Codable {
    let name: String?
    let targetAmount: Double
    let targetDate: Date?
    let createdDate: Date
    
    init(name: String?, targetAmount: Double, targetDate: Date?, createdDate: Date = Date()) {
        self.name = name
        self.targetAmount = targetAmount
        self.targetDate = targetDate
        self.createdDate = createdDate
    }
    
    var formattedTargetAmount: String {
        return String(format: "$%.2f", targetAmount)
    }
    
    var formattedTargetDate: String? {
        guard let targetDate = targetDate else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: targetDate)
    }
    
    func remainingAmount(currentAmount: Double) -> Double {
        return max(0, targetAmount - currentAmount)
    }
    
    func progress(currentAmount: Double) -> Double {
        guard targetAmount > 0 else { return 0 }
        return min(1.0, currentAmount / targetAmount)
    }
}

struct CompletedGoal: Codable, Identifiable {
    let id = UUID()
    let goal: Goal
    let completedDate: Date
    let finalAmount: Double
    
    var formattedCompletedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: completedDate)
    }
    
    var formattedFinalAmount: String {
        return String(format: "$%.2f", finalAmount)
    }
}
