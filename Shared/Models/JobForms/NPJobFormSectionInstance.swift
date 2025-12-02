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

    @Relationship(deleteRule: .cascade)
    var fields: [NPJobFormFieldInstance]

    // MARK: - Relationship: parent job form instance

    @Relationship
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

    // MARK: - Binding compatibility

    /// Provides a wrapped value interface so instances can be used with SwiftUI bindings
    /// that expect a `wrappedValue` property (e.g., `ForEach($sections) { $section in ... }`).
    ///
    /// This mirrors the semantics of `Binding.wrappedValue`, allowing read/write access
    /// to the underlying section instance when SwiftUI projects the model as a binding.
    var wrappedValue: NPJobFormSectionInstance {
        get { self }
        set {
            self.id = newValue.id
            self.title = newValue.title
            self.fields = newValue.fields
            self.form = newValue.form
        }
    }
}

