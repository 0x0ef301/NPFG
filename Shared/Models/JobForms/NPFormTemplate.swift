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

    /// Semantic version that increments whenever the template is edited.
    var version: Int

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
        version: Int = 1,
        created: Date = Date(),
        lastEdited: Date = Date(),
        sections: [NPFormSectionTemplate] = []
    ) {
        self.id = UUID()
        self.name = name
        self.detail = detail
        self.version = version
        self.created = created
        self.lastEdited = lastEdited
        self.sections = sections
    }

    // MARK: - Helpers

    func markEdited() {
        lastEdited = Date()
        version += 1
    }

    var isValidTemplate: Bool {
        sections.contains { !$0.fields.isEmpty }
    }
}

// MARK: - Conversion to job instances
extension NPFormTemplate {
    /// Creates a job-specific form instance cloned from this template.
    /// Relationships to sections and fields are deep-copied so the job can
    /// evolve independently while still tracking the originating template.
    func makeJobInstance(for job: NPJob? = nil) -> NPJobFormInstance {
        let jobForm = NPJobFormInstance(
            name: name,
            job: job,
            created: Date(),
            lastEdited: Date(),
            sections: []
        )

        jobForm.templateID = id
        jobForm.templateVersion = version
        jobForm.templateLastEdited = lastEdited

        for sectionTemplate in sections {
            let sectionInstance = NPJobFormSectionInstance(title: sectionTemplate.title, form: jobForm)

            for fieldTemplate in sectionTemplate.fields {
                let fieldInstance = NPJobFormFieldInstance(
                    key: fieldTemplate.key,
                    label: fieldTemplate.label,
                    typeRaw: fieldTemplate.type.rawValue,
                    isRequired: fieldTemplate.isRequired,
                    section: sectionInstance
                )
                sectionInstance.fields.append(fieldInstance)
            }

            jobForm.sections.append(sectionInstance)
        }

        jobForm.updateTimestamp()
        return jobForm
    }
}

