import SwiftUI

struct GoalView: View {
    @StateObject private var viewModel = GoalViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            AnimatedBackground()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Goal")
                            .font(AppFonts.title)
                            .foregroundColor(AppColors.darkBlue)
                        
                        Text("Set your savings target")
                            .font(AppFonts.caption)
                            .foregroundColor(AppColors.blue)
                    }
                    
                    Spacer()
                    
                    if viewModel.hasCompletedGoals {
                        Button(action: {
                            viewModel.showArchive = true
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "archivebox.fill")
                                    .font(.system(size: 16, weight: .medium))
                                Text("Archive")
                                    .font(AppFonts.caption)
                            }
                            .foregroundColor(AppColors.blue)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.white.opacity(0.3))
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.top, 20)
                .padding(.bottom, 24)
                .padding(.horizontal, 20)
                
                ScrollView {
                    VStack(spacing: 24) {
                        if let currentGoal = viewModel.currentGoal {
                            CardView {
                                VStack(spacing: 16) {
                                    HStack {
                                        Text("Current Goal")
                                            .font(AppFonts.subtitle)
                                            .foregroundColor(AppColors.darkBlue)
                                        
                                        Spacer()
                                        
                                        if viewModel.isGoalAchieved {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(AppColors.green)
                                        } else {
                                            Image(systemName: "target")
                                                .foregroundColor(AppColors.blue)
                                        }
                                    }
                                    
                                    VStack(spacing: 8) {
                                        if let name = currentGoal.name {
                                            HStack {
                                                Text("Name:")
                                                    .foregroundColor(AppColors.gray)
                                                Spacer()
                                                Text(name)
                                                    .foregroundColor(AppColors.darkBlue)
                                            }
                                        }
                                        
                                        HStack {
                                            Text("Target:")
                                                .foregroundColor(AppColors.gray)
                                            Spacer()
                                            Text(currentGoal.formattedTargetAmount)
                                                .foregroundColor(AppColors.darkBlue)
                                        }
                                        
                                        if let targetDate = currentGoal.formattedTargetDate {
                                            HStack {
                                                Text("Date:")
                                                    .foregroundColor(AppColors.gray)
                                                Spacer()
                                                Text(targetDate)
                                                    .foregroundColor(AppColors.darkBlue)
                                            }
                                        }
                                        
                                        if viewModel.isGoalAchieved {
                                            HStack {
                                                Text("Status:")
                                                    .foregroundColor(AppColors.gray)
                                                Spacer()
                                                Text("ACHIEVED! 🎉")
                                                    .foregroundColor(AppColors.green)
                                                    .fontWeight(.bold)
                                            }
                                        }
                                    }
                                    .font(AppFonts.caption)
                                    
                                    VStack(spacing: 12) {
                                        if viewModel.canCompleteGoal {
                                            GradientButton(
                                                title: "Complete Goal",
                                                icon: "trophy.fill"
                                            ) {
                                                viewModel.completeCurrentGoal()
                                            }
                                        }
                                        
                                        Button(action: {
                                            viewModel.clearCurrentGoal()
                                        }) {
                                            HStack {
                                                Image(systemName: "trash")
                                                    .font(.system(size: 14, weight: .medium))
                                                Text("Clear Goal")
                                                    .font(AppFonts.bodyMedium)
                                            }
                                            .foregroundColor(AppColors.red)
                                            .padding(.horizontal, 24)
                                            .padding(.vertical, 12)
                                            .background(
                                                RoundedRectangle(cornerRadius: 25)
                                                    .stroke(AppColors.red.opacity(0.3), lineWidth: 1)
                                            )
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                            }
                        }
                        
                        CardView {
                            VStack(spacing: 20) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(viewModel.currentGoal != nil ? "Update Goal" : "Set New Goal")
                                        .font(AppFonts.subtitle)
                                        .foregroundColor(AppColors.darkBlue)
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Goal Name (Optional)")
                                        .font(AppFonts.bodyMedium)
                                        .foregroundColor(AppColors.blue)
                                    
                                    TextField("e.g., New Car, Vacation", text: $viewModel.goalName)
                                        .font(AppFonts.body)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(AppColors.white)
                                                .overlay {
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .stroke(AppColors.blue.opacity(0.3), lineWidth: 1)
                                                }
                                        )
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Target Amount")
                                        .font(AppFonts.bodyMedium)
                                        .foregroundColor(AppColors.blue)
                                    
                                    HStack {
                                        Text("$")
                                            .font(AppFonts.bodyMedium)
                                            .foregroundColor(AppColors.blue)
                                        
                                        TextField("0.00", text: Binding(
                                            get: { viewModel.formatAmountForDisplay() },
                                            set: { viewModel.updateAmount(from: $0) }
                                        ))
                                            .font(AppFonts.body)
                                            .keyboardType(.decimalPad)
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(AppColors.white)
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(AppColors.blue.opacity(0.3), lineWidth: 1)
                                            }
                                    )
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Toggle("Set Target Date", isOn: $viewModel.hasTargetDate)
                                        .font(AppFonts.bodyMedium)
                                        .foregroundColor(AppColors.blue)
                                        .toggleStyle(SwitchToggleStyle(tint: AppColors.blue))
                                    
                                    if viewModel.hasTargetDate {
                                        DatePicker(
                                            "Target Date",
                                            selection: $viewModel.targetDate,
                                            in: Date()...,
                                            displayedComponents: .date
                                        )
                                        .font(AppFonts.body)
                                        .foregroundColor(AppColors.darkBlue)
                                    }
                                }
                                
                                GradientButton(
                                    title: viewModel.currentGoal != nil ? "Update Goal" : "Save Goal",
                                    isEnabled: viewModel.isButtonEnabled,
                                    icon: "checkmark"
                                ) {
                                    if viewModel.saveGoal() {
                                    }
                                }
                            }
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .alert("Goal Status", isPresented: $viewModel.showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.alertMessage)
        }
        .onAppear {
            viewModel.loadCurrentGoal()
        }
        .sheet(isPresented: $viewModel.showArchive) {
            GoalArchiveView(viewModel: viewModel)
        }
    }
}
