import SwiftUI

struct ContentView: View {
    @ObservedObject var dataManager = DataManager.shared
    @State private var selectedTab: TabType = .home
    @State private var showSplash = true
    
    var body: some View {
        Group {
            if showSplash {
                SplashScreenView(showSplash: $showSplash)
            } else if !dataManager.hasCompletedOnboarding {
                OnboardingView()
            } else {
                MainAppView(selectedTab: $selectedTab)
            }
        }
    }
}

struct MainAppView: View {
    @Binding var selectedTab: TabType
    
    var body: some View {
        ZStack {
            Group {
                switch selectedTab {
                case .home:
                    MainView()
                case .history:
                    HistoryView()
                case .analytics:
                    AnalyticsView()
                case .goal:
                    GoalView()
                case .statistics:
                    StatisticsView()
                }
            }
            
            VStack {
                Spacer()
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    ContentView()
}
