import SwiftData
import SwiftUI

struct TemplatePickerSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Query(sort: [SortDescriptor(\.name)]) private var templates: [NPFormTemplate]

    var onSelect: (NPJobFormInstance) -> Void

    var body: some View {
        NavigationStack {
            List {
                if templates.isEmpty {
                    emptyState
                } else {
                    ForEach(templates) { template in
                        Button {
                            let instance = template.makeJobInstance()
                            onSelect(instance)
                            dismiss()
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(template.name)
                                        .foregroundColor(.white)
                                    Text(template.detail ?? "")
                                        .foregroundColor(.gray)
                                        .font(.subheadline)
                                    Text("v\(template.version) • Updated \(template.lastEdited.formatted(date: .abbreviated, time: .shortened))")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        }
                        .listRowBackground(Color.black)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.black.ignoresSafeArea())
            .navigationTitle("Choose Template")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    private var emptyState: some View {
        VStack(alignment: .center, spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundColor(.orange)

            Text("No templates available")
                .foregroundColor(.white)
                .font(.headline)

            Text("Create a form template in the Forms tab before attaching it to a job.")
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
        .listRowBackground(Color.black)
    }
}
