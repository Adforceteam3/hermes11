import Foundation

struct SavingsEntry: Codable, Identifiable {
    let id = UUID()
    let date: Date
    let amount: Double
    let plannedAmount: Double
    
    var status: SavingsStatus {
        if amount >= plannedAmount {
            return .completed
        } else if amount > 0 {
            return .partial
        } else {
            return .missed
        }
    }
    
    var formattedAmount: String {
        return String(format: "$%.2f", amount)
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
}

enum SavingsStatus: String, CaseIterable {
    case completed = "Completed"
    case partial = "Partial"
    case missed = "Missed"
    
    var icon: String {
        switch self {
        case .completed:
            return "checkmark.circle.fill"
        case .partial:
            return "exclamationmark.circle.fill"
        case .missed:
            return "xmark.circle.fill"
        }
    }
    
    var color: String {
        switch self {
        case .completed:
            return "green"
        case .partial:
            return "yellow"
        case .missed:
            return "red"
        }
    }
}
