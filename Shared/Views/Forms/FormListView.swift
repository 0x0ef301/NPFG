//
//  FormListView.swift
//  NPFG
//
//  Created by Eric Stewart on 11/30/25.
//

import SwiftUI
import SwiftData

struct FormListView: View {

    @Environment(\.modelContext) private var context
    @EnvironmentObject var mediaManager: MediaManager

    @Bindable var job: NPJob

    @State private var showNewFormSheet = false

    var body: some View {
        NavigationStack {
            List {

                if job.forms.isEmpty {
                    emptyState
                } else {
                    ForEach(job.forms) { form in
                        NavigationLink {
                            FormRenderer(form: form)
                                .environmentObject(mediaManager)
                        } label: {
                            formRow(form)
                        }
                    }
                    .onDelete(perform: deleteForms)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.black.ignoresSafeArea())
            .navigationTitle(job.title)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showNewFormSheet = true
                    } label: {
                        Image(systemName: "doc.badge.plus")
                            .font(.title2)
                            .foregroundColor(.green)
                    }
                }
            }
            .sheet(isPresented: $showNewFormSheet) {
                NewFormSheet { newForm in
                    // Attach the new form to this job
                    newForm.job = job
                    job.forms.append(newForm)

                    // Persist changes
                    try? context.save()
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - Empty State
    private var emptyState: some View {
        VStack(alignment: .center, spacing: 12) {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(.gray)

            Text("No Forms Yet")
                .foregroundColor(.white)
                .font(.title3)

            Text("Tap the + button to add a form for this job.")
                .foregroundColor(.gray)
                .font(.subheadline)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.vertical, 60)
        .listRowBackground(Color.black)
    }

    // MARK: - Form Row
    private func formRow(_ form: NPForm) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(form.name)
                    .font(.headline)
                    .foregroundColor(.white)

                Text("Last edited: \(form.lastEdited.formatted(date: .abbreviated, time: .shortened))")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(.vertical, 6)
    }

    // MARK: - Delete Forms
    private func deleteForms(at offsets: IndexSet) {
        for index in offsets {
            let form = job.forms[index]
            context.delete(form)
        }
        job.forms.remove(atOffsets: offsets)
        try? context.save()
    }
}
