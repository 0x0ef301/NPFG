import Foundation
import Combine

final class AppState: ObservableObject {
    @Published var activeJobID: UUID? = nil
    @Published var xp: Int = 0
    @Published var badges: Set<String> = []

    // Registration
    @Published var operatorProfile: OperatorProfile? {
        didSet { saveOperatorProfile() }
    }

    private let operatorKey = "np.operatorProfile.v1"

    init() {
        self.operatorProfile = loadOperatorProfile()
    }

    private func saveOperatorProfile() {
        guard let profile = operatorProfile,
              let data = try? JSONEncoder().encode(profile)
        else {
            UserDefaults.standard.removeObject(forKey: operatorKey)
            return
        }
        UserDefaults.standard.set(data, forKey: operatorKey)
    }

    private func loadOperatorProfile() -> OperatorProfile? {
        guard let data = UserDefaults.standard.data(forKey: operatorKey),
              let profile = try? JSONDecoder().decode(OperatorProfile.self, from: data)
        else { return nil }
        return profile
    }
    
    func resetOperatorProfile() {
        operatorProfile = nil        // triggers save (removes user defaults)
        xp = 0
        badges.removeAll()
    }
}
