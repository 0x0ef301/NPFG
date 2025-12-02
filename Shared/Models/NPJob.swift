//
//  NPJob.swift
//  NPFG
//
//  Created by Eric Stewart on 11/30/25.
//

import Foundation
import SwiftData

/// A single Night Plinkers job / mission.
/// Example: "Silo #4 – East Field", "Warehouse – North Wing", etc.
@Model
class NPJob {

    // MARK: - Identity

    var id: UUID = UUID()

    // MARK: - Core Job Info

    /// Human-readable title for the job.
    var title: String

    /// When this job was created in the app.
    var created: Date = Date()

    // MARK: - Job-Specific Forms

    /// All filled form instances attached to this job.
    ///
    /// These are deep copies of NPFormTemplate, created as NPJobFormInstance
    /// when the operator adds a form to this job from the global template library.
    @Relationship(deleteRule: .cascade, inverse: \NPJobFormInstance.job)
    var forms: [NPJobFormInstance]

    // MARK: - Init

    init(
        title: String,
        created: Date = Date(),
        forms: [NPJobFormInstance] = []
    ) {
        self.id = UUID()
        self.title = title
        self.created = created
        self.forms = forms
    }
}

