import SwiftUI

struct AnalyticsView: View {
    @StateObject private var viewModel = AnalyticsViewModel()
    
    var body: some View {
        ZStack {
            AnimatedBackground()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack(spacing: 8) {
                    Text("Analytics")
                        .font(AppFonts.title)
                        .foregroundColor(AppColors.darkBlue)
                    
                    Text("Dynamics and statistics")
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
                                    ForEach(AnalyticsPeriod.allCases, id: \.self) { period in
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
                        
                        VStack(spacing: 12) {
                            HStack(spacing: 12) {
                                MetricCard(
                                    title: "Total Saved",
                                    value: viewModel.formattedTotalSaved,
                                    icon: "dollarsign.circle.fill",
                                    color: AppColors.green
                                )
                                
                                MetricCard(
                                    title: "Daily Average",
                                    value: viewModel.formattedAverageDailyAmount,
                                    icon: "chart.line.uptrend.xyaxis",
                                    color: AppColors.blue
                                )
                            }
                            
                            MetricCard(
                                title: "Completion Rate",
                                value: viewModel.formattedCompletionPercentage,
                                icon: "checkmark.circle.fill",
                                color: AppColors.green
                            )
                        }
                        
                        if !viewModel.candlestickData.isEmpty {
                            CardView {
                                VStack(spacing: 16) {
                                    HStack {
                                        Text("Savings Chart")
                                            .font(AppFonts.subtitle)
                                            .foregroundColor(AppColors.darkBlue)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chart.bar.fill")
                                            .foregroundColor(AppColors.blue)
                                    }
                                    
                                    CandlestickChart(
                                        data: viewModel.candlestickData,
                                        selectedCandle: $viewModel.selectedCandleData
                                    )
                                    .frame(height: 200)
                                }
                            }
                        }
                        
                        if let selectedCandle = viewModel.selectedCandleData {
                            CardView {
                                VStack(spacing: 12) {
                                    HStack {
                                        Text("Day Details")
                                            .font(AppFonts.bodyMedium)
                                            .foregroundColor(AppColors.darkBlue)
                                        
                                        Spacer()
                                        
                                        Image(systemName: selectedCandle.status.icon)
                                            .foregroundColor(selectedCandle.status == .completed ? AppColors.green : AppColors.red)
                                    }
                                    
                                    VStack(spacing: 8) {
                                        HStack {
                                            Text("Date:")
                                                .foregroundColor(AppColors.gray)
                                            Spacer()
                                            Text(selectedCandle.formattedDate)
                                                .foregroundColor(AppColors.darkBlue)
                                        }
                                        
                                        HStack {
                                            Text("Amount:")
                                                .foregroundColor(AppColors.gray)
                                            Spacer()
                                            Text(String(format: "$%.2f", selectedCandle.entryAmount))
                                                .foregroundColor(AppColors.darkBlue)
                                        }
                                        
                                        HStack {
                                            Text("Status:")
                                                .foregroundColor(AppColors.gray)
                                            Spacer()
                                            Text(selectedCandle.status.rawValue)
                                                .foregroundColor(AppColors.darkBlue)
                                        }
                                    }
                                    .font(AppFonts.caption)
                                }
                            }
                        }
                        
                        if !viewModel.topDays.isEmpty {
                            CardView {
                                VStack(spacing: 16) {
                                    HStack {
                                        Text("Top Days")
                                            .font(AppFonts.subtitle)
                                            .foregroundColor(AppColors.darkBlue)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "star.fill")
                                            .foregroundColor(AppColors.yellow)
                                    }
                                    
                                    ForEach(viewModel.topDays) { entry in
                                        HStack {
                                            Text(entry.formattedDate)
                                                .font(AppFonts.caption)
                                                .foregroundColor(AppColors.gray)
                                            
                                            Spacer()
                                            
                                            Text(entry.formattedAmount)
                                                .font(AppFonts.bodyMedium)
                                                .foregroundColor(AppColors.darkBlue)
                                        }
                                    }
                                }
                            }
                        }
                        
                        if viewModel.periodEntries.isEmpty {
                            CardView {
                                VStack(spacing: 16) {
                                    Image(systemName: "chart.bar.fill")
                                        .font(.system(size: 48, weight: .light))
                                        .foregroundColor(AppColors.gray)
                                    
                                    Text("No savings for analysis")
                                        .font(AppFonts.bodyMedium)
                                        .foregroundColor(AppColors.gray)
                                }
                                .padding(.vertical, 40)
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

struct MetricCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        CardView(padding: 16) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(color)
                
                Text(value)
                    .font(AppFonts.subtitle)
                    .foregroundColor(AppColors.darkBlue)
                
                Text(title)
                    .font(AppFonts.small)
                    .foregroundColor(AppColors.gray)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

struct CandlestickChart: View {
    let data: [CandlestickData]
    @Binding var selectedCandle: CandlestickData?
    
    var body: some View {
        GeometryReader { geometry in
            let maxValue = data.map { $0.high }.max() ?? 1
            let minValue = data.map { $0.low }.min() ?? 0
            let range = maxValue - minValue
            let safeRange = range > 0 ? range : 1
            
            HStack(alignment: .bottom, spacing: 2) {
                ForEach(data.indices, id: \.self) { index in
                    let candle = data[index]
                    let candleWidth = (geometry.size.width - CGFloat(data.count - 1) * 2) / CGFloat(data.count)
                    
                    VStack(spacing: 0) {
                        Rectangle()
                            .fill(candleColor(for: candle))
                            .frame(width: 1, height: max(1, (candle.high - candle.close) / safeRange * geometry.size.height))
                        
                        Rectangle()
                            .fill(candleColor(for: candle))
                            .frame(
                                width: candleWidth,
                                height: max(1, abs(candle.close - candle.open) / safeRange * geometry.size.height)
                            )
                        
                        Rectangle()
                            .fill(candleColor(for: candle))
                            .frame(width: 1, height: max(1, (candle.open - candle.low) / safeRange * geometry.size.height))
                    }
                    .onTapGesture {
                        selectedCandle = candle
                    }
                }
            }
        }
    }
    
    private func candleColor(for candle: CandlestickData) -> Color {
        if candle.isGreen {
            return AppColors.green
        } else if candle.isFlat {
            return AppColors.gray
        } else {
            return AppColors.red
        }
    }
}
