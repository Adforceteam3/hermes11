import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: TabType
    @Namespace private var animation
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabType.allCases, id: \.self) { tab in
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = tab
                    }
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(selectedTab == tab ? AppColors.blue : AppColors.gray)
                        
                        Text(tab.title)
                            .font(AppFonts.raleway(.medium, size: 10))
                            .foregroundColor(selectedTab == tab ? AppColors.blue : AppColors.gray)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(
                        ZStack {
                            if selectedTab == tab {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(AppColors.lightBlue.opacity(0.3))
                                    .matchedGeometryEffect(id: "selectedTab", in: animation)
                            }
                        }
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 20)
        .background(
            AppColors.white
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -5)
        )
    }
}

enum TabType: CaseIterable {
    case home
    case history
    case analytics
    case goal
    case statistics
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .history:
            return "History"
        case .analytics:
            return "Analytics"
        case .goal:
            return "Goal"
        case .statistics:
            return "Stats"
        }
    }
    
    var icon: String {
        switch self {
        case .home:
            return "house.fill"
        case .history:
            return "list.bullet.rectangle"
        case .analytics:
            return "chart.bar.fill"
        case .goal:
            return "target"
        case .statistics:
            return "chart.pie.fill"
        }
    }
}

#Preview {
    CustomTabBar(selectedTab: .constant(.home))
}
