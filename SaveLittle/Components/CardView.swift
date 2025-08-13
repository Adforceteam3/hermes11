import SwiftUI

struct CardView<Content: View>: View {
    let content: Content
    let padding: CGFloat
    
    init(padding: CGFloat = 16, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.padding = padding
    }
    
    var body: some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardGradient)
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            )
    }
}

struct GradientButton: View {
    let title: String
    let action: () -> Void
    let isEnabled: Bool
    let icon: String?
    
    init(title: String, isEnabled: Bool = true, icon: String? = nil, action: @escaping () -> Void) {
        self.title = title
        self.action = action
        self.isEnabled = isEnabled
        self.icon = icon
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                }
                Text(title)
                    .font(AppFonts.bodyMedium)
            }
            .foregroundColor(AppColors.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(
                isEnabled ? AppColors.buttonGradient : 
                LinearGradient(colors: [AppColors.gray], startPoint: .leading, endPoint: .trailing)
            )
            .cornerRadius(25)
        }
        .disabled(!isEnabled)
    }
}
