import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showRateAppAlert = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            AnimatedBackground()
                .ignoresSafeArea()
            
            
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 20, weight: .medium))
            }
            .position(x: UIScreen.main.bounds.width - 40, y: 40)
            
            
            VStack(spacing: 0) {
                VStack(spacing: 8) {
                    Text("Settings")
                        .font(AppFonts.title)
                        .foregroundColor(AppColors.darkBlue)
                    
                    Text("App preferences and information")
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.blue)
                }
                .padding(.top, 20)
                .padding(.bottom, 24)
                
                ScrollView {
                    VStack(spacing: 20) {
                        VStack(spacing: 16) {
                            HStack(spacing: 16) {
                                SettingsButton(
                                    title: "Privacy Policy",
                                    icon: "shield.checkerboard",
                                    color: AppColors.purple,
                                    style: .compact
                                ) {
                                    openURL("https://sites.google.com/adforcegroup.com/id-6751398366/")
                                }
                                
                                SettingsButton(
                                    title: "Terms of Use",
                                    icon: "doc.text",
                                    color: AppColors.blue,
                                    style: .compact
                                ) {
                                    openURL("https://sites.google.com/adforcegroup.com/id6751398366/")
                                }
                            }
                            
                            SettingsButton(
                                title: "Contact Support",
                                icon: "envelope.circle",
                                color: AppColors.green,
                                style: .wide
                            ) {
                                openURL("https://forms.gle/vW2Y39aVt29L1gLa6")
                            }
                            
                            SettingsButton(
                                title: "Rate App",
                                icon: "star.circle",
                                color: AppColors.yellow,
                                style: .compact
                            ) {
                                requestAppReview()
                            }
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

struct SettingsButton: View {
    let title: String
    let icon: String
    let color: Color
    let style: ButtonStyle
    let action: () -> Void
    
    enum ButtonStyle {
        case compact
        case wide
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: style == .wide ? 32 : 24, weight: .medium))
                    .foregroundColor(color)
                
                Text(title)
                    .font(style == .wide ? AppFonts.bodyMedium : AppFonts.caption)
                    .foregroundColor(AppColors.darkBlue)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, style == .wide ? 24 : 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.white)
                    .shadow(color: color.opacity(0.2), radius: 8, x: 0, y: 4)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
