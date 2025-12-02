import SwiftData
import Foundation

enum PreferredContact: String, Codable, CaseIterable, Hashable {
    case phone = "Phone"
    case email = "Email"
}

extension PreferredContact {
    var label: String {
        switch self {
        case .phone: return "Phone"
        case .email: return "Email"
        }
    }
}

@Model
class OperatorProfile {
    var id: UUID
    var fullName: String
    var phone: String
    var email: String
    var agency: String
    var preferredContact: PreferredContact

    init(
        fullName: String = "",
        phone: String = "",
        email: String = "",
        agency: String = "",
        preferredContact: PreferredContact = .phone
    ) {
        self.id = UUID()
        self.fullName = fullName
        self.phone = phone
        self.email = email
        self.agency = agency
        self.preferredContact = preferredContact
    }
}
