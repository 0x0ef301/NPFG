//
//  NPJobFormInstance.swift
//  NPFG
//
//  Created by Eric Stewart on 11/30/25.
//

import Foundation
import SwiftData

/// A job-specific form instance created from a NPFormTemplate.
/// This holds the operator's actual data for a single job.
@Model
class NPJobFormInstance {

    // MARK: - Identity

    var id: UUID = UUID()

    /// Display name of the form for this job.
    var name: String

    /// Originating form template metadata (for update propagation).
    var templateID: UUID?
    var templateVersion: Int?
    var templateLastEdited: Date?

    /// Timestamps
    var created: Date = Date()
    var lastEdited: Date = Date()

    // MARK: - Relationship: parent Job

    @Relationship
    var job: NPJob?

    // MARK: - Relationship: sections (deep copies from template)

    @Relationship(deleteRule: .cascade, inverse: \NPJobFormSectionInstance.form)
    var sections: [NPJobFormSectionInstance]

    // MARK: - Init

    init(
        name: String,
        job: NPJob? = nil,
        templateID: UUID? = nil,
        templateVersion: Int? = nil,
        templateLastEdited: Date? = nil,
        created: Date = Date(),
        lastEdited: Date = Date(),
        sections: [NPJobFormSectionInstance] = []
    ) {
        self.id = UUID()
        self.name = name
        self.job = job
        self.templateID = templateID
        self.templateVersion = templateVersion
        self.templateLastEdited = templateLastEdited
        self.created = created
        self.lastEdited = lastEdited
        self.sections = sections
    }

    // MARK: - Helpers

    func updateTimestamp() {
        lastEdited = Date()
    }
}
