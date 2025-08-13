import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    @ObservedObject var dataManager = DataManager.shared
    @State private var showSettings = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Save a Little")
                                .font(AppFonts.title)
                                .foregroundColor(AppColors.darkBlue)
                            
                            Text("Daily small steps")
                                .font(AppFonts.caption)
                                .foregroundColor(AppColors.blue)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            showSettings = true
                        }) {
                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(AppColors.blue)
                        }
                    }
                    .padding(.top, 20)
                    
                    CardView {
                        VStack(spacing: 20) {
                            VStack(spacing: 12) {
                                Text("Save Today: \(viewModel.formattedDailyAmount)")
                                    .font(AppFonts.subtitle)
                                    .foregroundColor(AppColors.darkBlue)
                                
                                HStack {
                                    Text("$")
                                        .font(AppFonts.bodyMedium)
                                        .foregroundColor(AppColors.blue)
                                    
                                    TextField("0.00", text: Binding(
                                        get: { viewModel.formatAmountForDisplay() },
                                        set: { viewModel.updateAmount(from: $0) }
                                    ))
                                        .font(AppFonts.bodyMedium)
                                        .foregroundColor(AppColors.darkBlue)
                                        .keyboardType(.decimalPad)
                                        .disabled(viewModel.hasEntryForToday)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(viewModel.hasEntryForToday ? AppColors.lightGray : AppColors.white)
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(AppColors.blue.opacity(0.3), lineWidth: 1)
                                        }
                                )
                            }
                            
                            if viewModel.hasEntryForToday {
                                Text("Today already completed")
                                    .font(AppFonts.caption)
                                    .foregroundColor(AppColors.green)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(AppColors.green.opacity(0.1))
                                    )
                            } else {
                                GradientButton(
                                    title: "Saved",
                                    isEnabled: viewModel.isButtonEnabled,
                                    icon: "checkmark"
                                ) {
                                    viewModel.saveToday()
                                }
                            }
                        }
                    }
                    
                    CardView {
                        VStack(spacing: 16) {
                            HStack {
                                Text("Total Saved:")
                                    .font(AppFonts.bodyMedium)
                                    .foregroundColor(AppColors.blue)
                                
                                Spacer()
                                
                                Text(viewModel.totalSaved)
                                    .font(AppFonts.subtitle)
                                    .foregroundColor(AppColors.darkBlue)
                            }
                            
                            if let goal = viewModel.currentGoal {
                                VStack(spacing: 12) {
                                    HStack {
                                        Text("For Current Goal:")
                                            .font(AppFonts.caption)
                                            .foregroundColor(AppColors.gray)
                                        
                                        Spacer()
                                        
                                        Text(viewModel.currentGoalSaved)
                                            .font(AppFonts.bodyMedium)
                                            .foregroundColor(AppColors.blue)
                                            .fontWeight(.medium)
                                    }
                                    
                                    ProgressView(value: viewModel.goalProgress)
                                        .progressViewStyle(LinearProgressViewStyle(tint: viewModel.isGoalAchieved ? AppColors.green : AppColors.blue))
                                        .scaleEffect(x: 1, y: 2, anchor: .center)
                                    
                                    HStack {
                                        Text("Goal: \(goal.formattedTargetAmount)")
                                            .font(AppFonts.caption)
                                            .foregroundColor(AppColors.blue)
                                        
                                        Spacer()
                                        
                                        if viewModel.isGoalAchieved {
                                            Text("ACHIEVED! 🎉")
                                                .font(AppFonts.caption)
                                                .foregroundColor(AppColors.green)
                                                .fontWeight(.bold)
                                        } else {
                                            Text("Remaining: \(viewModel.remainingToGoal)")
                                                .font(AppFonts.caption)
                                                .foregroundColor(AppColors.blue)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    WeeklyStatsModule(stats: viewModel.weeklyStats)
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
            }
        }
        .alert("Information", isPresented: $viewModel.showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.alertMessage)
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }
}

struct WeeklyStatsModule: View {
    let stats: WeeklyStatsData
    
    var body: some View {
        CardView {
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("This Week")
                            .font(AppFonts.subtitle)
                            .foregroundColor(AppColors.darkBlue)
                        
                        Text(getCurrentWeekText())
                            .font(AppFonts.small)
                            .foregroundColor(AppColors.gray)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "calendar.badge.clock")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(AppColors.blue)
                }
                
                HStack(spacing: 16) {
                    VStack(spacing: 4) {
                        Text(stats.formattedTotal)
                            .font(AppFonts.bodyMedium)
                            .foregroundColor(AppColors.darkBlue)
                            .fontWeight(.medium)
                        
                        Text("Total")
                            .font(AppFonts.small)
                            .foregroundColor(AppColors.gray)
                    }
                    .frame(maxWidth: .infinity)
                    
                    Divider()
                        .frame(height: 32)
                    
                    VStack(spacing: 4) {
                        Text(stats.formattedAverage)
                            .font(AppFonts.bodyMedium)
                            .foregroundColor(AppColors.blue)
                            .fontWeight(.medium)
                        
                        Text("Daily Avg")
                            .font(AppFonts.small)
                            .foregroundColor(AppColors.gray)
                    }
                    .frame(maxWidth: .infinity)
                    
                    Divider()
                        .frame(height: 32)
                    
                    VStack(spacing: 4) {
                        Text(stats.progressText)
                            .font(AppFonts.bodyMedium)
                            .foregroundColor(AppColors.green)
                            .fontWeight(.medium)
                        
                        Text("Days")
                            .font(AppFonts.small)
                            .foregroundColor(AppColors.gray)
                    }
                    .frame(maxWidth: .infinity)
                }
                
                VStack(spacing: 8) {
                    HStack {
                        Text("Week Progress")
                            .font(AppFonts.caption)
                            .foregroundColor(AppColors.gray)
                        
                        Spacer()
                        
                        Text("\(Int(stats.completionPercentage * 100))%")
                            .font(AppFonts.caption)
                            .foregroundColor(AppColors.blue)
                            .fontWeight(.medium)
                    }
                    
                    ProgressView(value: stats.completionPercentage)
                        .progressViewStyle(LinearProgressViewStyle(tint: AppColors.green))
                        .scaleEffect(x: 1, y: 1.5, anchor: .center)
                }
            }
        }
    }
    
    private func getCurrentWeekText() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        
        let calendar = Calendar.current
        let today = Date()
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: today)?.start ?? today
        let endOfWeek = calendar.dateInterval(of: .weekOfYear, for: today)?.end.addingTimeInterval(-1) ?? today
        
        return "\(formatter.string(from: startOfWeek)) - \(formatter.string(from: endOfWeek))"
    }
}
