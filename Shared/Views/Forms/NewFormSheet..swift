//
//  NewFormSheet.swift
//  NPFG
//
//  Created by Night Plinkers & Gert on 11/30/25.
//

import SwiftUI
import SwiftData

struct NewFormSheet: View {

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    @State private var formName: String = ""
    @State private var tempSections: [TempSection] = [
        TempSection(title: "New Section", fields: [])
    ]

    var onCreate: (NPJobFormInstance) -> Void

    struct TempSection: Identifiable {
        let id = UUID()
        var title: String
        var fields: [TempField]
    }

    struct TempField: Identifiable {
        let id = UUID()
        var label: String
        var type: NPFormFieldTemplate.FieldType
    }

    var body: some View {
        NavigationStack {
            Form {

                // MARK: - NAME
                Section("Form Name") {
                    TextField("Enter form name", text: $formName)
                }

                // MARK: - SECTIONS
                ForEach($tempSections) { $section in
                    Section {
                        TextField("Section Title", text: $section.title)

                        ForEach($section.fields) { $field in
                            HStack {
                                TextField("Field Label", text: $field.label)

                                Picker("", selection: $field.type) {
                                    ForEach(NPFormFieldTemplate.FieldType.allCases, id: \.self) { t in
                                        Text(t.rawValue).tag(t)
                                    }
                                }
                                .pickerStyle(.menu)
                            }
                        }

                        // MARK: Add Field
                        Button {
                            section.fields.append(
                                TempField(label: "New Field", type: .text)
                            )
                        } label: {
                            Label("Add Field", systemImage: "plus.circle")
                        }

                    } header: {
                        Text(section.title)
                    }
                }

                // MARK: Add Section
                Button {
                    tempSections.append(
                        TempSection(title: "New Section", fields: [])
                    )
                } label: {
                    Label("Add Section", systemImage: "plus.circle")
                }

            }
            .navigationTitle("New Form")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") { createForm() }
                        .disabled(formName.isEmpty)
                }
            }
        }
    }

    // MARK: - Create Form
    private func createForm() {

        let form = NPJobFormInstance(name: formName)

        for temp in tempSections {
            let section = NPJobFormSectionInstance(title: temp.title)

            for field in temp.fields {
                let newField = NPJobFormFieldInstance(
                    key: UUID().uuidString,       // REQUIRED NOW
                    label: field.label,
                    typeRaw: field.type.rawValue
                )
                section.fields.append(newField)
            }

            form.sections.append(section)
        }

        form.updateTimestamp()
        context.insert(form)

        try? context.save()

        onCreate(form)
        dismiss()
    }
}

