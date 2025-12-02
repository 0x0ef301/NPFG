//
//  Act3_OverviewView.swift
//  NPFG
//
//  Created by Eric Stewart on 10/21/25.
//

import SwiftUI

struct Act3_OverviewView: View {
    var body: some View {
        ActFlowView(def: def)
    }

    private var def: ActDefinition {
        ActDefinition(
            actNumber: 3,
            actTitle: "The Challenge",
            actSubtitle: "Execution & Control",
            steps: [
                ActStep(
                    title: "Pre-Departure Checklist",
                    textBullets: [
                        "Run weather and visibility checks one hour prior.",
                        "Crew fit confirmed, comms charged, airguns inspected.",
                        "Safety officer verifies PPE and lighting systems."
                    ],
                    imageName: "act3_departure",
                    caption: "Final readiness check — no excuses once wheels roll."
                ),
                ActStep(
                    title: "On-Site Execution",
                    textBullets: [
                        "Maintain safe arcs of fire and humane dispatch at all times.",
                        "Document every action — timestamps, media, and notes.",
                        "Adapt tactics as conditions change; stay inside plan parameters."
                    ],
                    imageName: "act3_execution",
                    caption: "Precision, patience, and professionalism in motion."
                ),
                ActStep(
                    title: "Adaptive Control Loop",
                    textBullets: [
                        "If targets shift or rebound, update the local plan immediately.",
                        "Communicate adjustments through the lead operator.",
                        "Record the rationale for every mid-mission change."
                    ],
                    imageName: "act3_adaptive",
                    caption: "Flexibility inside the framework keeps results consistent."
                ),
                ActStep(
                    title: "Documentation & Logs",
                    textBullets: [
                        "Complete Nightly AAR (After Action Report) for each operator.",
                        "Update recon maps if arcs or no-shoot zones change.",
                        "Upload photos/videos with time, GPS, and operator ID."
                    ],
                    imageName: "act3_logs",
                    caption: "Good data builds trust and scientific credibility."
                ),
                ActStep(
                    title: "Monitoring Snapshot",
                    textBullets: [
                        "Capture post-operation evidence for Act IV.",
                        "Take identical photos from baseline positions.",
                        "Log encounter counts or sightings for reduction metrics."
                    ],
                    imageName: "act3_monitor",
                    caption: "Today’s data becomes tomorrow’s proof of success."
                )
            ],
            nextActBuilder: {
                AnyView(Act4_OverviewView())
            }
        )
    }
}
