import SwiftUI
import SwiftData

@main
struct NPFieldApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var mediaManager = MediaManager.shared
    
    var body: some Scene {
        WindowGroup {
            AppRoot()
                .environmentObject(mediaManager)       // << REQUIRED
                .environmentObject(appState)   // ← REQUIRED
        }
        .modelContainer(for: [
            NPJob.self,
            NPJobFormInstance.self,
            NPJobFormSectionInstance.self,
            NPJobFormFieldInstance.self,
            NPMediaItem.self
        ])
    }
}


