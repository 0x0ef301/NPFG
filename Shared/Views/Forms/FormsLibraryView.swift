import SwiftData
import SwiftUI

struct FormsLibraryView: View {
    @Environment(\.modelContext) private var context

    @Query(sort: [SortDescriptor<NPFormTemplate>(\.lastEdited, order: .reverse)])
    private var templates: [NPFormTemplate]

    @State private var showingNewTemplateSheet = false

    init() {}

    var body: some View {
        NavigationStack {
            List {
                if templates.isEmpty {
                    emptyState
                } else {
                    ForEach(templates) { template in
                        NavigationLink {
                            TemplateDetailView(template: template)
                        } label: {
                            templateRow(template)
                        }
                    }
                    .onDelete(perform: deleteTemplates)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.black.ignoresSafeArea())
            .navigationTitle("Forms Library")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingNewTemplateSheet = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.green)
                    }
                }
            }
            .sheet(isPresented: $showingNewTemplateSheet) {
                NewTemplateSheet { newTemplate in
                    context.insert(newTemplate)
                    try? context.save()
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - Template Row
    private func templateRow(_ template: NPFormTemplate) -> some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: 6) {
                Text(template.name)
                    .foregroundColor(.white)
                    .font(.headline)
                Text(template.detail ?? "No description provided")
                    .foregroundColor(.gray)
                    .font(.subheadline)
                    .lineLimit(2)
                Text("v\(template.version) • Updated \(template.lastEdited.formatted(date: .abbreviated, time: .shortened))")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
    }

    // MARK: - Empty State
    private var emptyState: some View {
        VStack(alignment: .center, spacing: 12) {
            Image(systemName: "doc.richtext")
                .font(.system(size: 48))
                .foregroundColor(.gray)

            Text("No Templates Yet")
                .foregroundColor(.white)
                .font(.title3)

            Text("Create a template to start attaching forms to jobs.")
                .foregroundColor(.gray)
                .font(.subheadline)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.vertical, 60)
        .listRowBackground(Color.black)
    }

    // MARK: - Delete
    private func deleteTemplates(at offsets: IndexSet) {
        for index in offsets {
            let template = templates[index]
            context.delete(template)
        }
        try? context.save()
    }
}
