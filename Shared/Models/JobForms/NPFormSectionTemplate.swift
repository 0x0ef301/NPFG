//
//  NPFormSectionTemplate.swift
//  NPFG
//
//  Created by Eric Stewart on 11/30/25.
//

import Foundation
import SwiftData

/// A reusable section inside a form template.
/// Example: "Operator Info", "Carcass Handling", etc.
@Model
class NPFormSectionTemplate {

    // MARK: - Identity
    var id: UUID = UUID()

    /// Section title shown above its fields.
    var title: String

    // MARK: - Relationship to fields

    @Relationship(deleteRule: .cascade)
    var fields: [NPFormFieldTemplate]

    // MARK: - Relationship back to parent form template

    @Relationship
    var form: NPFormTemplate?

    // MARK: - Init

    init(
        title: String,
        fields: [NPFormFieldTemplate] = [],
        form: NPFormTemplate? = nil
    ) {
        self.id = UUID()
        self.title = title
        self.fields = fields
        self.form = form
    }
}

