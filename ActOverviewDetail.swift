//
//  ActOverviewDetail.swift
//  NPFG
//
//  Created by Eric Stewart on 10/21/25.
//

import SwiftUI

struct ActOverviewDetail: View {
    let act: ActIntro
    @State private var showPremium = false

    var body: some View {
        let d = act.data
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Title
                Text(d.title).font(.title).bold().foregroundColor(.white)
                Text(d.subtitle).font(.headline).foregroundColor(.green)

                // Intro paragraph
                Text(d.intro).foregroundColor(.white)

                // Sections
                ForEach(d.sections) { section in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(section.title).font(.headline).foregroundColor(.white)
                        VStack(alignment: .leading, spacing: 6) {
                            ForEach(section.bullets, id: \.self) { bullet in
                                HStack(alignment: .top, spacing: 8) {
                                    Circle().fill(Color.green).frame(width: 6, height: 6).padding(.top, 6)
                                    Text(bullet).foregroundColor(.white)
                                }
                            }
                        }
                    }
                    .padding(.top, 4)
                }

                // Deliverables
                if !d.deliverables.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Deliverables").font(.headline).foregroundColor(.white)
                        ForEach(d.deliverables, id: \.self) { item in
                            HStack(alignment: .top, spacing: 8) {
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundColor(.green)
                                Text(item).foregroundColor(.white)
                            }
                        }
                    }
                }

                // Premium CTA
                VStack(alignment: .leading, spacing: 8) {
                    Divider().overlay(Color.green)
                    Text("Go deeper").font(.headline).foregroundColor(.white)
                    Text(d.premiumPitch)
                        .foregroundColor(.gray)

                    Button {
                        showPremium = true
                    } label: {
                        Text("Unlock Premium Module")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                    .padding(.top, 4)
                }
                .padding(.top, 8)
            }
            .padding(16)
        }
        .background(Color.black.ignoresSafeArea())
        .sheet(isPresented: $showPremium) {
            PremiumPreviewView(act: act)
        }
    }
}

// Simple upsell screen (you can customize copy per act)
struct PremiumPreviewView: View {
    let act: ActIntro
    var body: some View {
        let d = act.data
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("\(d.title) — Premium")
                    .font(.title2).bold().foregroundColor(.white)
                Text("What you’ll unlock:")
                    .foregroundColor(.white)

                VStack(alignment: .leading, spacing: 8) {
                    switch act {
                    case .act1:
                        Text("• Interactive intake forms + digital signatures\n• Auto-generated Act I Authorization PDF\n• Calendar scheduling for Recon")
                    case .act2:
                        Text("• Map-based recon & safety plan builder\n• Legal memo templates & checklists\n• Team/tools readiness tracker")
                    case .act3:
                        Text("• Live shot log + GPS media tagging\n• Nightly AAR templates\n• Adaptive playbook prompts")
                    case .act4:
                        Text("• Reduction calculators & charts\n• Confidence interval report builder\n• Photo before/after comparison")
                    case .act5:
                        Text("• Prevention planner & reminders\n• Maintenance log for clients\n• Rapid response protocol kit")
                    }
                }
                .foregroundColor(.white)

                Spacer()
                Button("OK") { /* dismiss via swipe or button */ }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
            }
            .padding()
            .background(Color.black.ignoresSafeArea())
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { /* swipe down to dismiss */ }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}
