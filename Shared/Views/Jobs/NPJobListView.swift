//
//  NPJobListView.swift
//  NPFG
//
//  Created by Eric Stewart on 11/30/25.
//

import SwiftUI
import SwiftData

struct NPJobListView: View {

    @Environment(\.modelContext) private var context
    @Query(sort: \NPJob.created, order: .reverse) private var jobs: [NPJob]

    @State private var showNewJobSheet = false

    var body: some View {
        NavigationStack {
            List {

                if jobs.isEmpty {
                    emptyState
                } else {
                    ForEach(jobs) { job in
                        NavigationLink {
                            FormListView(job: job)
                        } label: {
                            jobRow(job)
                        }
                    }
                    .onDelete(perform: deleteJobs)
                }

            }
            .scrollContentBackground(.hidden)
            .background(Color.black.ignoresSafeArea())
            .navigationTitle("Jobs")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showNewJobSheet = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.green)
                    }
                }
            }
            .sheet(isPresented: $showNewJobSheet) {
                NewJobSheet { newJob in
                    // Insert the new job into SwiftData
                    context.insert(newJob)
                    try? context.save()
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - Empty State
    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "briefcase")
                .font(.system(size: 44))
                .foregroundColor(.gray)

            Text("No Jobs Yet")
                .foregroundColor(.white)
                .font(.title3)

            Text("Tap + to create your first job.")
                .foregroundColor(.gray)
                .font(.subheadline)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.vertical, 50)
        .listRowBackground(Color.black)
    }

    // MARK: - Job Row
    private func jobRow(_ job: NPJob) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(job.title)
                    .font(.headline)
                    .foregroundColor(.white)

                Text(job.created.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(.vertical, 6)
    }

    // MARK: - Delete Jobs
    private func deleteJobs(at offsets: IndexSet) {
        for index in offsets {
            let job = jobs[index]
            context.delete(job)
        }
        try? context.save()
    }
}

