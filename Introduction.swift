//
//  Introduction.swift
//  NPFG
//
//  Created by Eric Stewart on 10/21/25.
//

import SwiftUI

struct IntroductionView: View {
    var body: some View {
        // NOTE: Do NOT wrap in another NavigationStack if you're already pushing
        // IntroductionView from Home inside a NavigationStack.
        List {
            Section {
                NavigationLink {
                    Act1_OverviewView()
                } label: {
                    ActRow(title: "Act I — The Beginning", subtitle: "Discovery & Trust")
                }

                NavigationLink {
                    Act2_OverviewView()     // ← explicit destination
                } label: {
                    ActRow(title: "Act II — Setting the Stage", subtitle: "Planning & Preparation")
                }

                NavigationLink {
                    Act3_OverviewView()
                } label: {
                    ActRow(title: "Act III — The Challenge", subtitle: "Execution & Control")
                }

                NavigationLink {
                    Act4_OverviewView()
                } label: {
                    ActRow(title: "Act IV — The Turning Point", subtitle: "Measuring Success")
                }

                NavigationLink {
                    Act5_OverviewView()
                } label: {
                    ActRow(title: "Act V — The Resolution", subtitle: "Maintenance & Prevention")
                }
                
                NavigationLink {
                    Epilogue_OverviewView()
                } label: {
                    ActRow(title: "Epilogue — The Mission Continues", subtitle: "Wrap-up & next steps")
                }
            } header: {
                IntroHeader()
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.black.ignoresSafeArea())
        .preferredColorScheme(.dark)
        .navigationTitle("Introduction")
    }
}

private struct ActRow: View {
    let title: String
    let subtitle: String
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title).font(.headline).foregroundColor(.white)
            Text(subtitle).font(.subheadline).foregroundColor(.gray)
        }
        .padding(.vertical, 4)
    }
}

private struct IntroHeader: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image("NightPlinkersLogo")
                .resizable()
                .scaledToFit()
                .frame(height: 80)
                .shadow(color: .green.opacity(0.8), radius: 10)
            Text("Airgun Rodent Control – SOP Acts I–V Overview")
                .font(.subheadline)
                .foregroundColor(.gray)
            Text("Start with trust and clarity. Master the plan. Execute humanely. Measure honestly. Hold the ground you win.")
                .foregroundColor(.white)
                .font(.body)
        }
        .padding(.bottom, 8)
    }
}
