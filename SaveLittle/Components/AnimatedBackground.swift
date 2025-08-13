import SwiftUI

struct AnimatedBackground: View {
    @State private var moveCircles = false
    @State private var rotateShapes = false
    @State private var scaleShapes = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.85, green: 0.95, blue: 1.0),
                    Color(red: 0.95, green: 0.98, blue: 1.0),
                    Color.white
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            ForEach(0..<6, id: \.self) { index in
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                AppColors.blue.opacity(0.1),
                                AppColors.lightBlue.opacity(0.05)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: circleSize(for: index), height: circleSize(for: index))
                    .offset(
                        x: moveCircles ? circleEndPosition(for: index).x : circleStartPosition(for: index).x,
                        y: moveCircles ? circleEndPosition(for: index).y : circleStartPosition(for: index).y
                    )
                    .scaleEffect(scaleShapes ? 1.2 : 0.8)
                    .animation(
                        Animation.easeInOut(duration: Double.random(in: 8...12))
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.5),
                        value: moveCircles
                    )
                    .animation(
                        Animation.easeInOut(duration: 4)
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.3),
                        value: scaleShapes
                    )
            }
            
            ForEach(0..<4, id: \.self) { index in
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                AppColors.purple.opacity(0.08),
                                AppColors.blue.opacity(0.04)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: rectangleSize(for: index).width, height: rectangleSize(for: index).height)
                    .rotationEffect(.degrees(rotateShapes ? Double(index * 15) : Double(index * -10)))
                    .offset(
                        x: moveCircles ? rectangleEndPosition(for: index).x : rectangleStartPosition(for: index).x,
                        y: moveCircles ? rectangleEndPosition(for: index).y : rectangleStartPosition(for: index).y
                    )
                    .animation(
                        Animation.linear(duration: Double.random(in: 15...20))
                            .repeatForever(autoreverses: false)
                            .delay(Double(index) * 0.8),
                        value: rotateShapes
                    )
                    .animation(
                        Animation.easeInOut(duration: Double.random(in: 10...14))
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.6),
                        value: moveCircles
                    )
            }
            
            ForEach(0..<3, id: \.self) { index in
                Image(systemName: "dollarsign.circle")
                    .font(.system(size: 40, weight: .ultraLight))
                    .foregroundColor(AppColors.green.opacity(0.06))
                    .rotationEffect(.degrees(rotateShapes ? 360 : 0))
                    .offset(
                        x: dollarSignPosition(for: index).x,
                        y: moveCircles ? dollarSignPosition(for: index).y + 50 : dollarSignPosition(for: index).y - 50
                    )
                    .animation(
                        Animation.linear(duration: 20)
                            .repeatForever(autoreverses: false)
                            .delay(Double(index) * 2),
                        value: rotateShapes
                    )
                    .animation(
                        Animation.easeInOut(duration: 8)
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 1.5),
                        value: moveCircles
                    )
            }
            
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.white.opacity(0.3),
                    Color.clear,
                    Color.white.opacity(0.1)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        withAnimation {
            moveCircles = true
            rotateShapes = true
            scaleShapes = true
        }
    }
    
    private func circleSize(for index: Int) -> CGFloat {
        let sizes: [CGFloat] = [80, 120, 60, 100, 70, 90]
        return sizes[index % sizes.count]
    }
    
    private func circleStartPosition(for index: Int) -> CGPoint {
        let positions: [CGPoint] = [
            CGPoint(x: -100, y: 100),
            CGPoint(x: 300, y: -50),
            CGPoint(x: -50, y: 400),
            CGPoint(x: 250, y: 500),
            CGPoint(x: 150, y: -100),
            CGPoint(x: -80, y: 600)
        ]
        return positions[index % positions.count]
    }
    
    private func circleEndPosition(for index: Int) -> CGPoint {
        let positions: [CGPoint] = [
            CGPoint(x: 200, y: 300),
            CGPoint(x: -100, y: 400),
            CGPoint(x: 300, y: 200),
            CGPoint(x: -50, y: 100),
            CGPoint(x: 50, y: 500),
            CGPoint(x: 250, y: -50)
        ]
        return positions[index % positions.count]
    }
    
    private func rectangleSize(for index: Int) -> CGSize {
        let sizes: [CGSize] = [
            CGSize(width: 60, height: 40),
            CGSize(width: 80, height: 30),
            CGSize(width: 50, height: 60),
            CGSize(width: 70, height: 45)
        ]
        return sizes[index % sizes.count]
    }
    
    private func rectangleStartPosition(for index: Int) -> CGPoint {
        let positions: [CGPoint] = [
            CGPoint(x: 200, y: -80),
            CGPoint(x: -120, y: 250),
            CGPoint(x: 350, y: 350),
            CGPoint(x: 100, y: 700)
        ]
        return positions[index % positions.count]
    }
    
    private func rectangleEndPosition(for index: Int) -> CGPoint {
        let positions: [CGPoint] = [
            CGPoint(x: -100, y: 500),
            CGPoint(x: 300, y: 100),
            CGPoint(x: 50, y: -80),
            CGPoint(x: 280, y: 200)
        ]
        return positions[index % positions.count]
    }
    
    private func dollarSignPosition(for index: Int) -> CGPoint {
        let positions: [CGPoint] = [
            CGPoint(x: 80, y: 200),
            CGPoint(x: 200, y: 400),
            CGPoint(x: 300, y: 150)
        ]
        return positions[index % positions.count]
    }
}

#Preview {
    AnimatedBackground()
}
