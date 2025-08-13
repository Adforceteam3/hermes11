import SwiftUI

struct HistoryView: View {
    @StateObject private var viewModel = HistoryViewModel()
    
    var body: some View {
        ZStack {
            AnimatedBackground()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack(spacing: 8) {
                    Text("History")
                        .font(AppFonts.title)
                        .foregroundColor(AppColors.darkBlue)
                    
                    Text("All days")
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.blue)
                }
                .padding(.top, 20)
                .padding(.bottom, 24)
                
                ScrollView {
                    VStack(spacing: 20) {
                        CardView {
                            VStack(spacing: 16) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Period")
                                        .font(AppFonts.bodyMedium)
                                        .foregroundColor(AppColors.darkBlue)
                                    
                                    Picker("Period", selection: $viewModel.selectedPeriod) {
                                        ForEach(FilterPeriod.allCases, id: \.self) { period in
                                            Text(period.rawValue).tag(period)
                                        }
                                    }
                                    .pickerStyle(SegmentedPickerStyle())
                                }
                                
                                if viewModel.selectedPeriod == .dateRange {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Date Range")
                                            .font(AppFonts.bodyMedium)
                                            .foregroundColor(AppColors.darkBlue)
                                        
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
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Amount Range")
                                        .font(AppFonts.bodyMedium)
                                        .foregroundColor(AppColors.darkBlue)
                                    
                                    HStack {
                                        TextField("Min $", text: Binding(
                                            get: { viewModel.formatMinAmountForDisplay() },
                                            set: { viewModel.updateMinAmount(from: $0) }
                                        ))
                                            .keyboardType(.decimalPad)
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                        
                                        Text("to")
                                            .font(AppFonts.caption)
                                            .foregroundColor(AppColors.gray)
                                        
                                        TextField("Max $", text: Binding(
                                            get: { viewModel.formatMaxAmountForDisplay() },
                                            set: { viewModel.updateMaxAmount(from: $0) }
                                        ))
                                            .keyboardType(.decimalPad)
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                    }
                                }
                                
                                GradientButton(
                                    title: "Reset Filters",
                                    icon: "arrow.clockwise"
                                ) {
                                    viewModel.resetFilters()
                                }
                            }
                        }
                        
                        if viewModel.filteredEntries.isEmpty {
                            CardView {
                                VStack(spacing: 16) {
                                    Image(systemName: "list.bullet.rectangle")
                                        .font(.system(size: 48, weight: .light))
                                        .foregroundColor(AppColors.gray)
                                    
                                    Text("No data to display")
                                        .font(AppFonts.bodyMedium)
                                        .foregroundColor(AppColors.gray)
                                }
                                .padding(.vertical, 40)
                            }
                        } else {
                            LazyVStack(spacing: 8) {
                                ForEach(viewModel.filteredEntries) { entry in
                                    HistoryEntryRow(entry: entry)
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

struct HistoryEntryRow: View {
    let entry: SavingsEntry
    
    var body: some View {
        CardView(padding: 12) {
            HStack(spacing: 12) {
                Image(systemName: entry.status.icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(statusColor)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(entry.formattedDate)
                        .font(AppFonts.bodyMedium)
                        .foregroundColor(AppColors.darkBlue)
                    
                    Text(entry.status.rawValue)
                        .font(AppFonts.small)
                        .foregroundColor(AppColors.gray)
                }
                
                Spacer()
                
                Text(entry.formattedAmount)
                    .font(AppFonts.bodyMedium)
                    .foregroundColor(AppColors.darkBlue)
            }
        }
    }
    
    private var statusColor: Color {
        switch entry.status {
        case .completed:
            return AppColors.green
        case .partial:
            return AppColors.yellow
        case .missed:
            return AppColors.red
        }
    }
}
