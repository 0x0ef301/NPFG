//
//  Act5_Overview.swift
//  NPFG
//
//  Created by Eric Stewart on 10/21/25.
//

import SwiftUI

struct Act5_OverviewView: View {
    var body: some View {
        ActFlowView(def: def)
    }

    private var def: ActDefinition {
        ActDefinition(
            actNumber: 5,
            actTitle: "The Resolution",
            actSubtitle: "Maintenance & Prevention",
            steps: [
                ActStep(
                    title: "Transition to Prevention",
                    textBullets: [
                        "Confirm ≥ 70 % reduction benchmark was achieved in Act IV.",
                        "Discuss long-term prevention strategy aligned to client goals.",
                        "Shift mission language from *control* to *maintenance*."
                    ],
                    imageName: "act5_transition",
                    caption: "Success means stability — prevention becomes the new mission."
                ),
                ActStep(
                    title: "Exclusion & Habitat Modification",
                    textBullets: [
                        "Seal building penetrations, vents, and feed chutes.",
                        "Trim vegetation and remove stacked debris near structures.",
                        "Improve sanitation: feed storage, refuse bins, drain lines."
                    ],
                    imageName: "act5_exclusion",
                    caption: "Physical barriers and cleanliness sustain the win."
                ),
                ActStep(
                    title: "Maintenance Monitoring Program",
                    textBullets: [
                        "Schedule monthly inspections for the first quarter, then quarterly.",
                        "Use identical survey routes and digital forms for consistency.",
                        "Log zero-activity zones to prove continued success."
                    ],
                    imageName: "act5_monitoring",
                    caption: "Repetition with rigor builds long-term credibility."
                ),
                ActStep(
                    title: "Rapid Response Agreement",
                    textBullets: [
                        "Pre-authorize a 7-day response window if activity rebounds > 20 %.",
                        "Maintain communication chain for emergency redeployment.",
                        "Record response clauses in client’s ongoing service file."
                    ],
                    imageName: "act5_response",
                    caption: "Preparedness turns setbacks into demonstrations of reliability."
                ),
                ActStep(
                    title: "Client Education & Engagement",
                    textBullets: [
                        "Provide laminated species ID & exclusion cards.",
                        "Train client or staff to log and report new signs immediately.",
                        "Invite client to participate in social-proof testimonials."
                    ],
                    imageName: "act5_education",
                    caption: "Empower the client — prevention is a shared responsibility."
                )
            ],
            nextActBuilder: {
                AnyView(FinalCongratsView())
            }
        )
    }
}
