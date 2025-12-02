//
//  NPJobFormFieldInstance.swift
//  NPFG
//
//  Created by Eric Stewart on 11/30/25.
//

import Foundation
import SwiftData

/// A field instance filled out for a specific job/form.
/// This is the per-job copy of a NPFormFieldTemplate.
@Model
class NPJobFormFieldInstance {

    // MARK: - Identity

    var id: UUID = UUID()

    /// Stable key copied from the template.
    var key: String

    /// Label copied from template (can be updated if needed).
    var label: String

    /// Encoded type string copied from template (for rendering logic).
    var typeRaw: String

    /// Current value captured by operator (text, number, etc.).
    var value: String?

    /// Optional note or explanation.
    var note: String?

    /// Whether this field is required, copied from template.
    var isRequired: Bool

    /// Media items captured or attached for this field instance.
    @Relationship(deleteRule: .cascade, inverse: \NPMediaItem.field)
    var mediaItems: [NPMediaItem]

    // MARK: - Relationship: back to section instance

    @Relationship(inverse: \NPJobFormSectionInstance.fields)
    var section: NPJobFormSectionInstance?

    // MARK: - Init

    init(
        key: String,
        label: String,
        typeRaw: String,
        value: String? = nil,
        note: String? = nil,
        isRequired: Bool = false,
        section: NPJobFormSectionInstance? = nil,
        mediaItems: [NPMediaItem] = []
    ) {
        self.id = UUID()
        self.key = key
        self.label = label
        self.typeRaw = typeRaw
        self.value = value
        self.note = note
        self.isRequired = isRequired
        self.section = section
        self.mediaItems = mediaItems
    }
}

