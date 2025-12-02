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

    @Bindable var form: NPForm

    @State private var showSavedAlert = false
    @State private var scrollID = UUID()

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {

                VStack(alignment: .leading, spacing: 28) {

                    //----------------------------------------------------------------------
                    // MARK: FORM HEADER
                    //----------------------------------------------------------------------
                    VStack(alignment: .leading, spacing: 6) {

                        Text(form.name)
                            .font(.largeTitle.bold())
                            .foregroundColor(.white)

                        Text("Last edited: \(form.lastEdited.formatted(date: .abbreviated, time: .shortened))")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)

                    //----------------------------------------------------------------------
                    // MARK: SECTIONS + FIELDS
                    //----------------------------------------------------------------------
                    ForEach(form.sections) { section in
                        VStack(alignment: .leading, spacing: 16) {

                            Text(section.title)
                                .font(.title3.bold())
                                .foregroundColor(.green)
                                .padding(.horizontal)

                            ForEach(section.fields) { field in
                                FieldRenderer(form: form, field: field)
                                    .environmentObject(mediaManager)
                                    .padding(.horizontal)
                            }
                        }
                    }

                    Spacer(minLength: 40)
                }
                .padding(.top, 20)
                .id(scrollID)
            }
            .background(Color.black.ignoresSafeArea())
            .navigationTitle(form.name)
            .toolbar {
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
            .onAppear {
                // Auto-scroll to top on open
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    withAnimation(.easeInOut) {
                        proxy.scrollTo(scrollID, anchor: .top)
                    }
                }
            }
            .alert("Form Saved", isPresented: $showSavedAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Your entries and media have been securely saved.")
            }
        }
        .preferredColorScheme(.dark)
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

