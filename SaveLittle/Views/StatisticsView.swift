import SwiftUI

struct StatisticsView: View {
    @StateObject private var viewModel = StatisticsViewModel()
    
    var body: some View {
        ZStack {
            AnimatedBackground()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack(spacing: 8) {
                    Text("Statistics")
                        .font(AppFonts.title)
                        .foregroundColor(AppColors.darkBlue)
                    
                    Text("Daily performance insights")
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.blue)
                }
                .padding(.top, 20)
                .padding(.bottom, 24)
                
                ScrollView {
                    VStack(spacing: 20) {
                        CardView {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Period")
                                    .font(AppFonts.bodyMedium)
                                    .foregroundColor(AppColors.darkBlue)
                                
                                Picker("Period", selection: $viewModel.selectedPeriod) {
                                    ForEach(StatisticsPeriod.allCases, id: \.self) { period in
                                        Text(period.rawValue).tag(period)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                
                                if viewModel.selectedPeriod == .dateRange {
                                    HStack {
                                        DatePicker("From", selection: $viewModel.startDate, displayedComponents: .date)
                                            .labelsHidden()
                                        
                                        Text("to")
                                            .font(AppFonts.caption)
                                            .foregroundColor(AppColors.gray)
                                        
                                        DatePicker("To", selection: $viewModel.endDate, displayedComponents: .date)
                                            .labelsHidden()
                                    }
                                }
                            }
                        }
                        
                        if viewModel.periodEntries.isEmpty {
                            CardView {
                                VStack(spacing: 16) {
                                    Image(systemName: "chart.pie.fill")
                                        .font(.system(size: 48, weight: .light))
                                        .foregroundColor(AppColors.gray)
                                    
                                    Text("Not enough data for statistics")
                                        .font(AppFonts.bodyMedium)
                                        .foregroundColor(AppColors.gray)
                                }
                                .padding(.vertical, 40)
                            }
                        } else {
                            VStack(spacing: 12) {
                                HStack(spacing: 12) {
                                    StatCard(
                                        title: "Days Completed",
                                        value: "\(viewModel.daysWithEntries)",
                                        icon: "checkmark.circle.fill",
                                        color: AppColors.green
                                    )
                                    
                                    StatCard(
                                        title: "Days Missed",
                                        value: "\(viewModel.daysMissed)",
                                        icon: "xmark.circle.fill",
                                        color: AppColors.red
                                    )
                                }
                                
                                StatCard(
                                    title: "Average on Completed Days",
                                    value: viewModel.formattedAverageAmount,
                                    icon: "chart.bar.fill",
                                    color: AppColors.blue
                                )
                            }
                            
                            CardView {
                                VStack(spacing: 16) {
                                    HStack {
                                        Text("Streaks")
                                            .font(AppFonts.subtitle)
                                            .foregroundColor(AppColors.darkBlue)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "flame.fill")
                                            .foregroundColor(AppColors.orange)
                                    }
                                    
                                    VStack(spacing: 12) {
                                        HStack {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text("Longest Completion Streak")
                                                    .font(AppFonts.bodyMedium)
                                                    .foregroundColor(AppColors.darkBlue)
                                                
                                                Text("\(viewModel.longestCompletionStreak) days")
                                                    .font(AppFonts.caption)
                                                    .foregroundColor(AppColors.green)
                                            }
                                            
                                            Spacer()
                                            
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(AppColors.green)
                                        }
                                        
                                        Divider()
                                        
                                        HStack {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text("Longest Missed Streak")
                                                    .font(AppFonts.bodyMedium)
                                                    .foregroundColor(AppColors.darkBlue)
                                                
                                                Text("\(viewModel.longestMissedStreak) days")
                                                    .font(AppFonts.caption)
                                                    .foregroundColor(AppColors.red)
                                            }
                                            
                                            Spacer()
                                            
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(AppColors.red)
                                        }
                                    }
                                }
                            }
                            
                            if !viewModel.weeklyComparison.isEmpty {
                                CardView {
                                    VStack(spacing: 16) {
                                        HStack {
                                            Text("Weekly Comparison")
                                                .font(AppFonts.subtitle)
                                                .foregroundColor(AppColors.darkBlue)
                                            
                                            Spacer()
                                            
                                            Image(systemName: "calendar")
                                                .foregroundColor(AppColors.blue)
                                        }
                                        
                                        VStack(spacing: 8) {
                                            HStack {
                                                Text("Week")
                                                    .font(AppFonts.small)
                                                    .foregroundColor(AppColors.gray)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                
                                                Text("Completion")
                                                    .font(AppFonts.small)
                                                    .foregroundColor(AppColors.gray)
                                                    .frame(width: 80)
                                                
                                                Text("Average")
                                                    .font(AppFonts.small)
                                                    .foregroundColor(AppColors.gray)
                                                    .frame(width: 60)
                                            }
                                            
                                            Divider()
                                            
                                            ForEach(viewModel.weeklyComparison, id: \.weekLabel) { week in
                                                HStack {
                                                    Text(week.weekLabel)
                                                        .font(AppFonts.caption)
                                                        .foregroundColor(AppColors.darkBlue)
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                    
                                                    Text(week.formattedCompletionPercentage)
                                                        .font(AppFonts.caption)
                                                        .foregroundColor(AppColors.blue)
                                                        .frame(width: 80)
                                                    
                                                    Text(week.formattedAverageAmount)
                                                        .font(AppFonts.caption)
                                                        .foregroundColor(AppColors.darkBlue)
                                                        .frame(width: 60)
                                                }
                                            }
                                        }
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
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        CardView(padding: 16) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(color)
                    .frame(width: 32)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(value)
                        .font(AppFonts.subtitle)
                        .foregroundColor(AppColors.darkBlue)
                    
                    Text(title)
                        .font(AppFonts.small)
                        .foregroundColor(AppColors.gray)
                }
                
                Spacer()
            }
        }
    }
}
