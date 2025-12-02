//
//  NPMediaItem.swift
//  NPFG
//
//  Created by Night Plinkers & Gert on 11/30/25.
//

import Foundation
import SwiftData

/// Type of media captured or attached to a form field.
enum MediaType: String, Codable, CaseIterable {
    case photo
    case video
    case audio
}

/// SwiftData model for a single media item stored in the app sandbox.
@Model
class NPMediaItem {

    // Unique identifier
    var id: UUID = UUID()

    // What kind of media is this?
    var type: MediaType

    // Original filename (for human readability / export)
    var originalFileName: String

    // Full file path inside the app sandbox
    // Example: .../Documents/Media/<UUID>.jpg
    var filePath: String

    // When the media was created / attached
    var createdAt: Date = Date()

    // Optional caption or notes (e.g., "Burrow cluster behind barn.")
    var note: String?

    // Parent field this media is associated with (optional)
    @Relationship
    var field: NPJobFormFieldInstance?

    // MARK: - Initializer
    init(
        type: MediaType,
        originalFileName: String,
        filePath: String,
        createdAt: Date = Date(),
        note: String? = nil,
        field: NPJobFormFieldInstance? = nil
    ) {
        self.id = UUID()
        self.type = type
        self.originalFileName = originalFileName
        self.filePath = filePath
        self.createdAt = createdAt
        self.note = note
        self.field = field
    }
}
