//
//  NPFormFieldTemplate.swift
//  NPFG
//
//  Created by Eric Stewart on 11/30/25.
//

import Foundation
import SwiftData

/// A reusable field definition inside a form template.
/// This does NOT store any operator data, only structure.
@Model
class NPFormFieldTemplate {

    // MARK: - Identity
    var id: UUID = UUID()

    /// Stable key for this field inside the template.
    /// Example: "carcass_location", "operator_signature"
    var key: String

    /// Display label for the operator.
    var label: String

    /// Encoded type (text, number, checkbox, etc.)
    var type: FieldType

    /// Whether this field must be filled in.
    var isRequired: Bool

    // MARK: - Relationship back to section template

    @Relationship(inverse: \NPFormSectionTemplate.fields)
    var section: NPFormSectionTemplate?

    // MARK: - FieldType

    enum FieldType: String, Codable, CaseIterable {
        case text
        case number
        case checkbox
        case date
        case time
        case yesNo
        case location
        case signature
        case mediaNote
    }

    // MARK: - Init

    init(
        key: String,
        label: String,
        type: FieldType,
        isRequired: Bool = false,
        section: NPFormSectionTemplate? = nil
    ) {
        self.id = UUID()
        self.key = key
        self.label = label
        self.type = type
        self.isRequired = isRequired
        self.section = section
    }
}

