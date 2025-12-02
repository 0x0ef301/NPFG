import Foundation
import Combine
import SwiftData
import SwiftUI

@Observable
final class AppState: ObservableObject {

    // MARK: - Simple published values
    var activeJobID: UUID? = nil
    var xp: Int = 0
    var badges: Set<String> = []

    // MARK: - SwiftData injected modelContext
    // AppState does NOT create its own storage — it uses the shared container.
    @ObservationIgnored
    var modelContext: ModelContext?

    // Cached in-memory profile for convenience
    var operatorProfile: OperatorProfile? {
        didSet {
            saveOperatorProfile()
        }
    }

    init() {
        // SwiftData loads profile lazily once modelContext is attached
        self.operatorProfile = nil
    }

    // MARK: - MUST be called from the app's first screen
    func attach(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadOperatorProfile()
    }

    // MARK: - Load Operator Profile from SwiftData
    private func loadOperatorProfile() {
        guard let context = modelContext else { return }

        let descriptor = FetchDescriptor<OperatorProfile>()
        let profiles = (try? context.fetch(descriptor)) ?? []

        if let existing = profiles.first {
            self.operatorProfile = existing
        } else {
            self.operatorProfile = nil
        }
    }

    // MARK: - Save Operator Profile
    private func saveOperatorProfile() {
        guard let context = modelContext,
              let profile = operatorProfile else { return }

        // If this model is NOT already in a SwiftData context → insert it
        if profile.modelContext == nil {
            context.insert(profile)
        }

        try? context.save()
    }

    // MARK: - Reset
    func resetOperatorProfile() {
        guard let context = modelContext else { return }

        if let profile = operatorProfile {
            context.delete(profile)
            try? context.save()
        }

        operatorProfile = nil
        xp = 0
        badges.removeAll()
    }
}

