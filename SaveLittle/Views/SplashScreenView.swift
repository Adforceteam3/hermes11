import SwiftUI

struct SplashScreenView: View {
    @State private var isLoading = true
    @State private var rotationAngle: Double = 0
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    @Binding var showSplash: Bool
    
    var body: some View {
        ZStack {
            AnimatedBackground()
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                ZStack {
                    Circle()
                        .fill(AppColors.buttonGradient)
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(rotationAngle))
                        .scaleEffect(scale)
                        .opacity(opacity)
                        .overlay {
                            Circle()
                                .trim(from: 0, to: 0.3)
                                .stroke(AppColors.darkBlue, lineWidth: 10)
                                .scaleEffect(scale)
                                .rotationEffect(.degrees(rotationAngle))
                        }
                    
                    Image(systemName: "dollarsign.circle.fill")
                        .font(.system(size: 60, weight: .bold))
                        .foregroundColor(AppColors.white)
                        .scaleEffect(scale)
                        .opacity(opacity)
                }
                
                VStack(spacing: 8) {
                    Text("SaveLittle")
                        .font(AppFonts.largeTitle)
                        .foregroundColor(AppColors.darkBlue)
                        .opacity(opacity)
                    
                }
                
                if isLoading {
                    HStack(spacing: 8) {
                        ForEach(0..<3) { index in
                            Circle()
                                .fill(AppColors.blue)
                                .frame(width: 8, height: 8)
                                .scaleEffect(scale)
                                .animation(
                                    Animation.easeInOut(duration: 0.6)
                                        .repeatForever(autoreverses: true)
                                        .delay(Double(index) * 0.2),
                                    value: scale
                                )
                        }
                    }
                    .padding(.top, 20)
                }
            }
        }
        .onAppear {
            startAnimations()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation(.easeOut(duration: 0.5)) {
                    showSplash = false
                }
            }
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeOut(duration: 1.0)) {
            scale = 1.0
            opacity = 1.0
        }
        
        withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeOut(duration: 0.3)) {
                isLoading = false
            }
        }
    }
}

#Preview {
    SplashScreenView(showSplash: .constant(true))
}
