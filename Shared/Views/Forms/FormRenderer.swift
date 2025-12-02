//
//  FormRenderer.swift
//  NPFG
//
//  Created by Eric Stewart on 11/29/25.
//

import SwiftUI
import SwiftData

struct FormRenderer: View {

    @Environment(\.modelContext) private var context
    @EnvironmentObject var mediaManager: MediaManager

    @Bindable var form: NPJobFormInstance

    @State private var showSavedAlert = false
    @State private var scrollID = UUID()

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                formContent
                    .id(scrollID)
            }
            .background(Color.black.ignoresSafeArea())
            .navigationTitle(form.name)
            .toolbar { saveButton }
            .onAppear { scrollToTop(proxy: proxy) }
            .alert("Form Saved", isPresented: $showSavedAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Your entries and media have been securely saved.")
            }
        }
        .preferredColorScheme(.dark)
    }

    @ViewBuilder
    private var formContent: some View {
        VStack(alignment: .leading, spacing: 28) {
            formHeader
                .padding(.horizontal)

            formSections

            Spacer(minLength: 40)
        }
        .padding(.top, 20)
    }

    @ViewBuilder
    private var formHeader: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(form.name)
                .font(.largeTitle.bold())
                .foregroundColor(.white)

            Text("Last edited: \(form.lastEdited.formatted(date: .abbreviated, time: .shortened))")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }

    @ViewBuilder
    private var formSections: some View {
        ForEach($form.sections, id: \.id) { $section in
            VStack(alignment: .leading, spacing: 16) {
                Text(section.wrappedValue.title)
                    .font(.title3.bold())
                    .foregroundColor(.green)
                    .padding(.horizontal)

                ForEach($section.fields, id: \.id) { $field in
                    FieldRenderer(field: field)
                        .environmentObject(mediaManager)
                        .padding(.horizontal)
                }
            }
        }
    }

    private var saveButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                saveForm()
            } label: {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(.green)
            }
        }
    }

    private func scrollToTop(proxy: ScrollViewProxy) {
        // Auto-scroll to top on open
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.easeInOut) {
                proxy.scrollTo(scrollID, anchor: .top)
            }
        }
    }

    // ------------------------------------------------------------------
    // MARK: SAVE HANDLER
    // ------------------------------------------------------------------
    private func saveForm() {
        form.lastEdited = Date()
        try? context.save()
        showSavedAlert = true
    }
}

