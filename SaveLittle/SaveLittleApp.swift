import SwiftUI

@main
struct SaveLittleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    registerCustomFonts()
                }
        }
    }
    
    private func registerCustomFonts() {
        let fontNames = [
            "Raleway-Light",
            "Raleway-Regular", 
            "Raleway-Medium",
            "Raleway-SemiBold",
            "Raleway-Bold"
        ]
        
        for fontName in fontNames {
            if let fontURL = Bundle.main.url(forResource: fontName, withExtension: "ttf") {
                CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, nil)
            }
        }
    }
}
