//
//  NewJobSheet.swift
//  NPFG
//
//  Created by Eric Stewart on 11/30/25.
//

import SwiftUI
import SwiftData

struct NewJobSheet: View {

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    /// Callback to deliver the new job to NPJobListView
    let onCreate: (NPJob) -> Void

    @State private var title: String = ""
    @State private var showInvalidAlert = false

    var body: some View {
        NavigationStack {
            Form {

                Section("Job Title") {
                    TextField("Enter job name", text: $title)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.words)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.black.ignoresSafeArea())
            .navigationTitle("New Job")
            .preferredColorScheme(.dark)
            .toolbar {

                // Cancel button
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }

                // Create button
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") { createJob() }
                        .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .alert("Invalid Job Name", isPresented: $showInvalidAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("A job must have a name.")
            }
        }
    }

    // MARK: - Create Job
    private func createJob() {

        let cleanTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !cleanTitle.isEmpty else {
            showInvalidAlert = true
            return
        }

        let job = NPJob(title: cleanTitle)

        context.insert(job)
        try? context.save()

        onCreate(job)
        dismiss()
    }
}
