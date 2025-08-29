import SwiftUI

@main
struct SaveLittleApp: App {
    
    init() {
        let counter = UserDefaults.standard.integer(forKey: "counter")
        UserDefaults.standard.set(counter + 1, forKey: "counter")
        
        if UserDefaults.standard.string(forKey: "userID") == nil {
            let symbols = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            var userID = ""
            for _ in 0..<20 {
                let element = symbols.randomElement()!
                userID.append(element)
            }
            UserDefaults.standard.set(userID, forKey: "userID")
        }
        
        let userID = UserDefaults.standard.string(forKey: "userID") ?? ""
    }
    
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
