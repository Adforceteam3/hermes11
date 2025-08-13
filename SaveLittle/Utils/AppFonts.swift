import SwiftUI

struct AppFonts {
    static func raleway(_ weight: RalewayWeight, size: CGFloat) -> Font {
        return Font.custom(weight.rawValue, size: size)
    }
    
    enum RalewayWeight: String {
        case light = "Raleway-Light"
        case regular = "Raleway-Regular"
        case medium = "Raleway-Medium"
        case semiBold = "Raleway-SemiBold"
        case bold = "Raleway-Bold"
    }
    
    static let title = raleway(.bold, size: 28)
    static let subtitle = raleway(.semiBold, size: 20)
    static let body = raleway(.regular, size: 16)
    static let bodyMedium = raleway(.medium, size: 16)
    static let caption = raleway(.regular, size: 14)
    static let small = raleway(.regular, size: 12)
    static let largeTitle = raleway(.bold, size: 34)
}
