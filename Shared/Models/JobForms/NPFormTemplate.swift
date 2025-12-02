//
//  NPFormTemplate.swift
//  NPFG
//
//  Created by Eric Stewart on 11/30/25.
//

import Foundation
import SwiftData

/// A reusable, global form definition template.
/// These define structure only; job data lives in NPJobFormInstance.
@Model
class NPFormTemplate {

    // MARK: - Identity

    var id: UUID = UUID()

    /// Name for the template shown in the Forms library.
/// Example: "Carcass Collection Report", "Night Recon Log".
    var name: String

    /// Optional description for the operator.
    var detail: String?

    // MARK: - Timestamps

    var created: Date = Date()
    var lastEdited: Date = Date()

    // MARK: - Section templates

    @Relationship(deleteRule: .cascade, inverse: \NPFormSectionTemplate.form)
    var sections: [NPFormSectionTemplate]

    // MARK: - Init

    init(
        name: String,
        detail: String? = nil,
        created: Date = Date(),
        lastEdited: Date = Date(),
        sections: [NPFormSectionTemplate] = []
    ) {
        self.id = UUID()
        self.name = name
        self.detail = detail
        self.created = created
        self.lastEdited = lastEdited
        self.sections = sections
    }

    // MARK: - Helpers

    func updateTimestamp() {
        lastEdited = Date()
    }

    var isValidTemplate: Bool {
        sections.contains { !$0.fields.isEmpty }
    }
}

