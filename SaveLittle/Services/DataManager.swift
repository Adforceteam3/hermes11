import Foundation

class DataManager: ObservableObject {
    static let shared = DataManager()
    
    @Published var savingsEntries: [SavingsEntry] = []
    @Published var currentGoal: Goal?
    @Published var completedGoals: [CompletedGoal] = []
    @Published var hasCompletedOnboarding: Bool = false
    
    private let userDefaults = UserDefaults.standard
    private let savingsEntriesKey = "SaveLittle_SavingsEntries"
    private let goalKey = "SaveLittle_Goal"
    private let completedGoalsKey = "SaveLittle_CompletedGoals"
    private let onboardingKey = "SaveLittle_HasCompletedOnboarding"
    private let dailyAmountKey = "SaveLittle_DailyAmount"
    
    private init() {
        loadData()
    }
    
    var dailyPlannedAmount: Double {
        return userDefaults.object(forKey: dailyAmountKey) as? Double ?? 2.00
    }
    
    func setDailyPlannedAmount(_ amount: Double) {
        userDefaults.set(amount, forKey: dailyAmountKey)
    }
    
    var totalSaved: Double {
        return savingsEntries.reduce(0) { $0 + $1.amount }
    }
    
    var formattedTotalSaved: String {
        return String(format: "$%.2f", totalSaved)
    }
    
    var currentGoalSaved: Double {
        guard let goal = currentGoal else { return 0 }
        return savingsEntries
            .filter { $0.date >= goal.createdDate }
            .reduce(0) { $0 + $1.amount }
    }
    
    var formattedCurrentGoalSaved: String {
        return String(format: "$%.2f", currentGoalSaved)
    }
    
    func hasEntryForToday() -> Bool {
        let today = Calendar.current.startOfDay(for: Date())
        return savingsEntries.contains { entry in
            Calendar.current.isDate(entry.date, inSameDayAs: today)
        }
    }
    
    func addSavingsEntry(amount: Double) {
        let today = Date()
        let entry = SavingsEntry(
            date: today,
            amount: amount,
            plannedAmount: dailyPlannedAmount
        )
        
        if !hasEntryForToday() {
            savingsEntries.append(entry)
            savingsEntries.sort { $0.date > $1.date }
            saveData()
        }
    }
    
    func setGoal(_ goal: Goal) {
        currentGoal = goal
        saveData()
    }
    
    func isCurrentGoalAchieved() -> Bool {
        guard let goal = currentGoal else { return false }
        return currentGoalSaved >= goal.targetAmount
    }
    
    func completeCurrentGoal() {
        guard let goal = currentGoal, isCurrentGoalAchieved() else { return }
        
        let completedGoal = CompletedGoal(
            goal: goal,
            completedDate: Date(),
            finalAmount: currentGoalSaved
        )
        completedGoals.append(completedGoal)
        completedGoals.sort { $0.completedDate > $1.completedDate }
        
        currentGoal = nil
        saveData()
    }
    
    func clearCurrentGoal() {
        currentGoal = nil
        saveData()
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        userDefaults.set(true, forKey: onboardingKey)
    }
    
    private func loadData() {
        hasCompletedOnboarding = userDefaults.bool(forKey: onboardingKey)
        
        if let data = userDefaults.data(forKey: savingsEntriesKey) {
            do {
                savingsEntries = try JSONDecoder().decode([SavingsEntry].self, from: data)
                savingsEntries.sort { $0.date > $1.date }
            } catch {
                print("Failed to load savings entries: \(error)")
                savingsEntries = []
            }
        }
        
        if let data = userDefaults.data(forKey: goalKey) {
            do {
                currentGoal = try JSONDecoder().decode(Goal.self, from: data)
            } catch {
                print("Failed to load goal: \(error)")
                currentGoal = nil
            }
        }
        
        if let data = userDefaults.data(forKey: completedGoalsKey) {
            do {
                completedGoals = try JSONDecoder().decode([CompletedGoal].self, from: data)
                completedGoals.sort { $0.completedDate > $1.completedDate }
            } catch {
                print("Failed to load completed goals: \(error)")
                completedGoals = []
            }
        }
    }
    
    private func saveData() {
        do {
            let data = try JSONEncoder().encode(savingsEntries)
            userDefaults.set(data, forKey: savingsEntriesKey)
        } catch {
            print("Failed to save savings entries: \(error)")
        }
        
        if let goal = currentGoal {
            do {
                let data = try JSONEncoder().encode(goal)
                userDefaults.set(data, forKey: goalKey)
            } catch {
                print("Failed to save goal: \(error)")
            }
        } else {
            userDefaults.removeObject(forKey: goalKey)
        }
        
        do {
            let data = try JSONEncoder().encode(completedGoals)
            userDefaults.set(data, forKey: completedGoalsKey)
        } catch {
            print("Failed to save completed goals: \(error)")
        }
    }
}
