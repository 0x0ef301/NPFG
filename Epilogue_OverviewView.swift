//
//  Epilogue_OverviewView.swift
//  NPFG
//
//  Created by Eric Stewart on 10/29/25.
//

import SwiftUI

struct Epilogue_OverviewView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showPremium = false
    @State private var showFinal = false

    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading, spacing: 16) {

                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Epilogue")
                            .font(.title.bold())
                            .foregroundColor(.white)
                        Text("Continuous Improvement")
                            .font(.headline)
                            .foregroundColor(.green)
                        Text("The mission is complete, the numbers prove success, and prevention is in place. Yet every operation leaves behind lessons. The Epilogue is where the Night Plinkers story acknowledges that even the best SOPs must evolve — shaped by experience, law, and community.")
                            .foregroundColor(.white)
                    }

                    // 1. Community Relations & Transparency
                    SectionCard(
                        title: "1. Community Relations & Transparency",
                        bullets: [
                            "Neighbor notifications: Maintain goodwill by letting surrounding landowners know when operations were completed, and that prevention steps are now active.",
                            "Public signage: If signs were posted during control rounds, remove or update them with “Operation Complete — Monitoring Only” notices.",
                            "Media response: Keep a short, respectful statement ready in case of public inquiry: emphasize humane methods, legal compliance, and success in protecting agriculture and property."
                        ],
                        voiceCue: "“Rodent control isn’t just about the land you stand on — it’s about trust with the people around it.”"
                    )

                    // 2. Quality Assurance & Audits
                    SectionCard(
                        title: "2. Quality Assurance & Audits",
                        bullets: [
                            "Quarterly QA audits: Randomly select at least 10% of completed job files and review for:",
                            "Legal compliance documentation.",
                            "Properly filled operator logs.",
                            "Humane dispatch verification (photos, notes).",
                            "Annual SOP review: Laws change, tools evolve. At least once a year, re-check Texas state statutes, county ordinances, and city codes. Update SOPs accordingly.",
                            "Operator refreshers: Require annual requalification in marksmanship, humane dispatch, and biosecurity."
                            ]
                        )

                    // 3. Training & Knowledge Sharing
                    SectionCard(
                        title: "3. Training & Knowledge Sharing",
                        bullets: [
                            "Operator debriefs: Capture lessons learned — what worked, what didn’t — after each job.",
                            "Update training modules: Feed these lessons into operator training and certification programs.",
                            "Knowledge base: Maintain a central, living repository of field tips, improved tactics, and regulatory updates."
                        ]
                    )

                    // 4. Innovation & Adaptation
                    SectionCard(
                        title: "4. Innovation & Adaptation",
                        bullets: [
                            "New technology adoption: Trial emerging tools — improved thermal optics, AI-assisted camera monitoring, pellet innovations — in controlled pilot projects before SOP integration.",
                            "Complementary methods: Evaluate how exclusion, terrier teams, or smart traps may ethically augment airgun control in specific use cases.",
                            "Continuous metrics: Track long-term client outcomes to measure whether 70% reduction held over months and years."
                        ]
                    )

                    // 5. Long-Term Recordkeeping
                    SectionCard(
                        title: "5. Long-Term Recordkeeping",
                        bullets: [
                            "Retention: Keep operation files (logs, photos, reports) for at least five years for liability and research.",
                            "Accessibility: Ensure files are organized for easy retrieval during audits, grant reviews, or legal inquiries.",
                            "Contribution to science: Share anonymized data with wildlife damage management programs or universities when appropriate, to improve regional understanding of rodent control."
                        ]
                    )

                    // 6. Closing Reflection (with voice cue)
                    SectionCard(
                        title: "6. Closing Reflection",
                        bullets: [
                            "Every operation is more than a job — it’s a contribution to the balance between human need and animal ecology. By ending with community engagement, audits, and shared knowledge, the cycle of continuous improvement ensures Night Plinkers remains trusted, effective, and ahead of the curve."
                        ],
                        voiceCue: "“The story doesn’t end here. Each mission teaches us something new — and the next chapter starts with what we learned today.”"
                    )

                    

                    // 7. Epilogue Deliverables
                    VStack(alignment: .leading, spacing: 10) {
                        bullet("Act I: Discovery & trust; the 70% target.")
                        bullet("Act II: Lawful, safe, prepared.")
                        bullet("Act III: Humane, documented execution.")
                        bullet("Act IV: Numbers prove success.")
                        bullet("Act V: Prevention keeps it.")
                    }
                    .padding(.horizontal, 28)

                    Button {
                        showFinal = true
                    } label: {
                        Label("Finish Introduction", systemImage: "checkmark.seal.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                    .padding(.top, 8)

                    // Spacer at bottom
                    Spacer(minLength: 8)
                }
                .padding(16)
            }
            .scrollIndicators(.visible)              // NEW
            .scrollBounceBehavior(.basedOnSize)      // NEW
            .background(Color.black.ignoresSafeArea())
            
            .navigationTitle("Epilogue")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showPremium = true
                    } label: {
                        Label("Unlock", systemImage: "lock.open.fill")
                            .foregroundColor(.green)
                    }
                }
            }
        }
        
        .sheet(isPresented: $showPremium) {
            // Simple stub—replace with your paywall later
            NavigationStack {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Premium Modules")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                    Text("Unlock in-depth modules for each Act and SOP, including interactive forms, signatures, mapping, calculators, and exportable PDFs.")
                        .foregroundColor(.gray)
                    Spacer()
                    Button("Close") { showPremium = false }
                        .buttonStyle(.borderedProminent)
                        .tint(.green)
                }
                .padding()
                .background(Color.black.ignoresSafeArea())
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Close") { showPremium = false }
                    }
                }
            }
            .preferredColorScheme(.dark)
        }
        .preferredColorScheme(.dark)
        
        .fullScreenCover(isPresented: $showFinal) {
            EpilogueView(
                onUnlockPremium: { /* later: paywall */ },
                onReturnHome: {
                    // Close the final screen back to Overview,
                    // then the user can tap back to return Home
                    // (Or you can pop multiple levels using a coordinator later)
                }
            )
        }

    }
    private func bullet(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Circle().fill(Color.green).frame(width: 6, height: 6).padding(.top, 6)
            Text(text).foregroundColor(.white)
        }
    }
}

// MARK: - Small building blocks

private struct SectionCard: View {
    let title: String
    let bullets: [String]
    var voiceCue: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionTitle(title)
            ForEach(bullets, id: \.self) { Bullet($0) }
            if let voice = voiceCue {
                VoiceCue(voice)
            }
        }
        .padding(16)
        .background(.black.opacity(0.5))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(.green.opacity(0.6), lineWidth: 1))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .green.opacity(0.25), radius: 12)
        
    }
}

@ViewBuilder private func SectionTitle(_ text: String) -> some View {
    Text(text)
        .font(.headline)
        .foregroundColor(.white)
}

@ViewBuilder private func Bullet(_ text: String) -> some View {
    HStack(alignment: .top, spacing: 8) {
        Circle().fill(Color.green).frame(width: 6, height: 6).padding(.top, 6)
        Text(text).foregroundColor(.white)
    }
}

@ViewBuilder private func SubBullet(_ text: String) -> some View {
    HStack(alignment: .top, spacing: 8) {
        Circle().fill(Color.green.opacity(0.7)).frame(width: 5, height: 5).padding(.top, 6)
        Text(text).foregroundColor(.white.opacity(0.95))
    }
    .padding(.leading, 18)
}

@ViewBuilder private func VoiceCue(_ text: String) -> some View {
    HStack(alignment: .top, spacing: 10) {
        Image(systemName: "quote.opening")
            .foregroundColor(.green)
        Text(text)
            .italic()
            .foregroundColor(.white)
    }
    .padding(.top, 6)
}

