import SwiftData
import SwiftUI

struct NewTemplateSheet: View {
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var detail: String = ""
    @State private var tempSections: [TempSection] = [TempSection(title: "New Section", fields: [])]

    var onCreate: (NPFormTemplate) -> Void

    struct TempSection: Identifiable {
        let id = UUID()
        var title: String
        var fields: [TempField]
    }

    struct TempField: Identifiable {
        let id = UUID()
        var label: String
        var type: NPFormFieldTemplate.FieldType
        var isRequired: Bool
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Template Info") {
                    TextField("Name", text: $name)
                    TextField("Description", text: $detail)
                }

                ForEach($tempSections) { $section in
                    Section(section.title) {
                        TextField("Section Title", text: $section.title)

                        ForEach($section.fields) { $field in
                            VStack(alignment: .leading, spacing: 8) {
                                TextField("Field Label", text: $field.label)
                                Picker("Type", selection: $field.type) {
                                    ForEach(NPFormFieldTemplate.FieldType.allCases, id: \.self) { option in
                                        Text(option.rawValue).tag(option)
                                    }
                                }
                                Toggle("Required", isOn: $field.isRequired)
                            }
                        }
                        .onDelete { offsets in
                            section.fields.remove(atOffsets: offsets)
                        }

                        Button {
                            section.fields.append(
                                TempField(label: "New Field", type: .text, isRequired: false)
                            )
                        } label: {
                            Label("Add Field", systemImage: "plus.circle")
                        }
                    }
                }
                .onDelete { offsets in
                    tempSections.remove(atOffsets: offsets)
                }

                Button {
                    tempSections.append(TempSection(title: "New Section", fields: []))
                } label: {
                    Label("Add Section", systemImage: "plus")
                }
            }
            .navigationTitle("New Template")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") { createTemplate() }
                        .disabled(name.isEmpty || !hasAtLeastOneField)
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    private var hasAtLeastOneField: Bool {
        tempSections.contains { !$0.fields.isEmpty }
    }

    private func createTemplate() {
        let template = NPFormTemplate(name: name, detail: detail.isEmpty ? nil : detail)

        for section in tempSections {
            let sectionModel = NPFormSectionTemplate(title: section.title, fields: [], form: template)

            for field in section.fields {
                let fieldModel = NPFormFieldTemplate(
                    key: UUID().uuidString,
                    label: field.label,
                    type: field.type,
                    isRequired: field.isRequired,
                    section: sectionModel
                )
                sectionModel.fields.append(fieldModel)
            }

            template.sections.append(sectionModel)
        }

        onCreate(template)
        dismiss()
    }
}
