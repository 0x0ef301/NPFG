import SwiftData
import SwiftUI

struct TemplateDetailView: View {
    @Environment(\.modelContext) private var context
    @Bindable var template: NPFormTemplate

    var body: some View {
        Form {
            Section("Template Info") {
                TextField("Template Name", text: $template.name)
                TextField("Description", text: Binding($template.detail, replacingNilWith: ""))
            }

            ForEach($template.sections) { $section in
                Section(section.title.isEmpty ? "Section" : section.title) {
                    TextField("Section Title", text: $section.title)

                    ForEach($section.fields) { $field in
                        VStack(alignment: .leading, spacing: 8) {
                            TextField("Field Label", text: $field.label)
                            Picker("Type", selection: $field.type) {
                                ForEach(NPFormFieldTemplate.FieldType.allCases, id: \.self) { fieldType in
                                    Text(fieldType.rawValue).tag(fieldType)
                                }
                            }
                            .pickerStyle(.segmented)
                            Toggle("Required", isOn: $field.isRequired)
                        }
                    }
                    .onDelete { indexSet in
                        section.fields.remove(atOffsets: indexSet)
                    }

                    Button {
                        section.fields.append(
                            NPFormFieldTemplate(
                                key: UUID().uuidString,
                                label: "New Field",
                                type: .text,
                                isRequired: false,
                                section: section
                            )
                        )
                    } label: {
                        Label("Add Field", systemImage: "plus.circle")
                    }
                }
            }
            .onDelete { offsets in
                template.sections.remove(atOffsets: offsets)
            }

            Button {
                template.sections.append(
                    NPFormSectionTemplate(title: "New Section", fields: [])
                )
            } label: {
                Label("Add Section", systemImage: "plus")
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.black.ignoresSafeArea())
        .navigationTitle(template.name.isEmpty ? "Template" : template.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    template.markEdited()
                    try? context.save()
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

private extension Binding where Value == String {
    init(_ base: Binding<String?>, replacingNilWith placeholder: String) {
        self.init(
            get: { base.wrappedValue ?? placeholder },
            set: { base.wrappedValue = $0 }
        )
    }
}
