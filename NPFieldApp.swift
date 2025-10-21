import SwiftUI

@main
struct NPFieldApp: App {
    @StateObject private var appState = AppState()
    var body: some Scene {
        WindowGroup {
            AppRoot()
                .environmentObject(appState)
                .preferredColorScheme(.dark)   // keep global dark theme
        }
    }
}
