import SwiftUI

struct AppColors {
    static let lightBlue = Color(red: 0.85, green: 0.95, blue: 1.0)
    static let blue = Color(red: 0.2, green: 0.4, blue: 0.8)
    static let darkBlue = Color(red: 0.1, green: 0.2, blue: 0.6)
    static let white = Color.white
    static let lightGray = Color(red: 0.95, green: 0.95, blue: 0.97)
    static let gray = Color(red: 0.7, green: 0.7, blue: 0.7)
    static let green = Color(red: 0.2, green: 0.7, blue: 0.3)
    static let yellow = Color(red: 1.0, green: 0.8, blue: 0.0)
    static let red = Color(red: 0.9, green: 0.2, blue: 0.2)
    static let orange = Color(red: 1.0, green: 0.6, blue: 0.0)
    static let purple = Color(red: 0.6, green: 0.2, blue: 0.8)
    
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [lightBlue, white]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        gradient: Gradient(colors: [white, lightGray]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let buttonGradient = LinearGradient(
        gradient: Gradient(colors: [blue, darkBlue]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
