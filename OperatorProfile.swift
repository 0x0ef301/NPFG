//
//  OperatorProfile.swift
//  NPFG
//
//  Created by Eric Stewart on 10/21/25.
//

import Foundation

struct OperatorProfile: Codable, Equatable {
    var fullName: String
    var phone: String
    var email: String
    var preferredContact: PreferredContact

    enum PreferredContact: String, Codable, CaseIterable, Identifiable {
        case phone, email, text
        var id: String { rawValue }
        var label: String {
            switch self {
            case .phone: return "Phone Call"
            case .email: return "Email"
            case .text:  return "Text Message"
            }
        }
    }
}
