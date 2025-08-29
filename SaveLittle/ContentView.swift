import SwiftUI
import StoreKit

struct ContentView: View {
    @ObservedObject var dataManager = DataManager.shared
    @State private var selectedTab: TabType = .home
    @State private var showSplash = true
    @State private var screen: Bool = false
    @State private var showALert: Bool = false
    
    var body: some View {
        Group {
            if showSplash {
                SplashScreenView()
                    .onAppear {
                        InitMethod.shared.initScreen { bool, alert in
                            screen = bool
                            showALert = alert
                            DispatchQueue.main.async {
                                showSplash = false
                            }
                        }
                    }
            } else if screen {
                MarkView()
                    .onAppear {
                        if UserDefaults.standard.integer(forKey: "counter") == 2 {
                            requestReview()
                        }
                    }
            } else if !dataManager.hasCompletedOnboarding {
                OnboardingView()
            } else {
                MainAppView(selectedTab: $selectedTab)
            }
        }
    }
    
    fileprivate func requestReview() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
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
