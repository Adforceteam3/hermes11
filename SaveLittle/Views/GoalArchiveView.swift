import SwiftUI

struct GoalArchiveView: View {
    @ObservedObject var viewModel: GoalViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            AnimatedBackground()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(AppColors.blue)
                            .frame(width: 32, height: 32)
                            .background(
                                Circle()
                                    .fill(AppColors.white)
                                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                            )
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 4) {
                        Text("Goal Archive")
                            .font(AppFonts.title)
                            .foregroundColor(AppColors.darkBlue)
                        
                        Text("Completed goals")
                            .font(AppFonts.caption)
                            .foregroundColor(AppColors.blue)
                    }
                    
                    Spacer()
                    
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: 32, height: 32)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 24)
                
                if viewModel.completedGoals.isEmpty {
                    Spacer()
                    
                    CardView {
                        VStack(spacing: 16) {
                            Image(systemName: "archivebox")
                                .font(.system(size: 48, weight: .light))
                                .foregroundColor(AppColors.gray)
                            
                            Text("No completed goals yet")
                                .font(AppFonts.bodyMedium)
                                .foregroundColor(AppColors.gray)
                            
                            Text("Complete your first goal to see it here!")
                                .font(AppFonts.caption)
                                .foregroundColor(AppColors.gray)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.vertical, 40)
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.completedGoals) { completedGoal in
                                CompletedGoalCard(completedGoal: completedGoal)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    }
                }
            }
        }
    }
}

struct CompletedGoalCard: View {
    let completedGoal: CompletedGoal
    
    var body: some View {
        CardView {
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        if let name = completedGoal.goal.name {
                            Text(name)
                                .font(AppFonts.bodyMedium)
                                .foregroundColor(AppColors.darkBlue)
                        } else {
                            Text("Goal")
                                .font(AppFonts.bodyMedium)
                                .foregroundColor(AppColors.darkBlue)
                        }
                        
                        Text("Completed on \(completedGoal.formattedCompletedDate)")
                            .font(AppFonts.small)
                            .foregroundColor(AppColors.gray)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "trophy.fill")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(AppColors.yellow)
                }
                
                VStack(spacing: 8) {
                    HStack {
                        Text("Target Amount:")
                            .font(AppFonts.caption)
                            .foregroundColor(AppColors.gray)
                        
                        Spacer()
                        
                        Text(completedGoal.goal.formattedTargetAmount)
                            .font(AppFonts.caption)
                            .foregroundColor(AppColors.darkBlue)
                            .fontWeight(.medium)
                    }
                    
                    HStack {
                        Text("Final Amount:")
                            .font(AppFonts.caption)
                            .foregroundColor(AppColors.gray)
                        
                        Spacer()
                        
                        Text(completedGoal.formattedFinalAmount)
                            .font(AppFonts.caption)
                            .foregroundColor(AppColors.green)
                            .fontWeight(.medium)
                    }
                    
                    if let targetDate = completedGoal.goal.formattedTargetDate {
                        HStack {
                            Text("Target Date:")
                                .font(AppFonts.caption)
                                .foregroundColor(AppColors.gray)
                            
                            Spacer()
                            
                            Text(targetDate)
                                .font(AppFonts.caption)
                                .foregroundColor(AppColors.darkBlue)
                        }
                    }
                }
                
                HStack {
                    Spacer()
                    
                    HStack(spacing: 6) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(AppColors.green)
                        
                        Text("ACHIEVED")
                            .font(AppFonts.small)
                            .foregroundColor(AppColors.green)
                            .fontWeight(.bold)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(AppColors.green.opacity(0.1))
                    )
                    
                    Spacer()
                }
            }
        }
    }
}
