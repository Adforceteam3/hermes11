import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @ObservedObject var dataManager = DataManager.shared
    
    private let pages = [
        OnboardingPage(
            image: "dollarsign.circle.fill",
            title: "Save a Little Every Day",
            description: "Turn small daily savings into big results. Each day, the app gives you a simple amount to set aside — just enter it and watch your balance grow."
        ),
        OnboardingPage(
            image: "chart.line.uptrend.xyaxis",
            title: "Track Your Progress",
            description: "Track your progress toward a goal, view your history of deposits, and explore trends with clear charts, including candlestick views to see how your savings change over time."
        ),
        OnboardingPage(
            image: "target",
            title: "Stay Consistent",
            description: "Stay consistent, keep your streak going, and see how even a small habit can lead to impressive achievements."
        )
    ]
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? AppColors.blue : AppColors.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                .padding(.top, 50)
                
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.3), value: currentPage)
                
                VStack(spacing: 16) {
                    if currentPage == pages.count - 1 {
                        GradientButton(
                            title: "Get Started",
                            icon: "arrow.right"
                        ) {
                            dataManager.completeOnboarding()
                        }
                        .padding(.horizontal, 40)
                    } else {
                        GradientButton(
                            title: "Continue",
                            icon: "arrow.right"
                        ) {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentPage += 1
                            }
                        }
                        .padding(.horizontal, 40)
                    }
                    
                    if currentPage < pages.count - 1 {
                        Button(action: {
                            dataManager.completeOnboarding()
                        }) {
                            Text("Skip")
                                .font(AppFonts.bodyMedium)
                                .foregroundColor(AppColors.blue)
                        }
                    }
                }
                .padding(.bottom, 40)
            }
        }
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: page.image)
                .font(.system(size: 100, weight: .light))
                .foregroundColor(AppColors.blue)
                .padding(.bottom, 20)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(AppFonts.title)
                    .foregroundColor(AppColors.darkBlue)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                Text(page.description)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.blue)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 30)
            }
            
            Spacer()
        }
    }
}

struct OnboardingPage {
    let image: String
    let title: String
    let description: String
}
