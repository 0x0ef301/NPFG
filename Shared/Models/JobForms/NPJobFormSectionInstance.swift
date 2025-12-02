//
//  NPJobFormSectionInstance.swift
//  NPFG
//
//  Created by Eric Stewart on 11/30/25.
//

import Foundation
import SwiftData

/// A section instance inside a job-specific form.
/// This is a deep copy of a NPFormSectionTemplate.
@Model
class NPJobFormSectionInstance {

    // MARK: - Identity

    var id: UUID = UUID()

    /// Section title as seen by operator.
    var title: String

    // MARK: - Relationship: fields in this section

    @Relationship(deleteRule: .cascade, inverse: \NPJobFormFieldInstance.section)
    var fields: [NPJobFormFieldInstance]

    // MARK: - Relationship: parent job form instance

    @Relationship(inverse: \NPJobFormInstance.sections)
    var form: NPJobFormInstance?

    // MARK: - Init

    init(
        title: String,
        fields: [NPJobFormFieldInstance] = [],
        form: NPJobFormInstance? = nil
    ) {
        self.id = UUID()
        self.title = title
        self.fields = fields
        self.form = form
    }
}

