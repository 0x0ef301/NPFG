//
//  Act4_Overview.swift
//  NPFG
//
//  Created by Eric Stewart on 10/21/25.
//

import SwiftUI

struct Act4_OverviewView: View {
    var body: some View {
        ActFlowView(def: def)
    }

    private var def: ActDefinition {
        ActDefinition(
            actNumber: 4,
            actTitle: "The Turning Point",
            actSubtitle: "Measuring Success",
            steps: [
                ActStep(
                    title: "Re-Survey & Monitoring",
                    textBullets: [
                        "Repeat field measures at 2 / 4 / 8 weeks using the same routes and methods.",
                        "Log sightings, burrow counts, feed consumption, and track activity zones.",
                        "Ensure conditions match baseline (time, temperature, feed availability)."
                    ],
                    imageName: "act4_resurvey",
                    caption: "Consistency makes your data trustworthy."
                ),
                ActStep(
                    title: "Data & Statistical Comparison",
                    textBullets: [
                        "Calculate reduction % using encounter indices or trap-night counts.",
                        "Use the same sample units as Act I baseline.",
                        "Record confidence intervals; verify significance of change."
                    ],
                    imageName: "act4_data",
                    caption: "When the math proves it, the work speaks for itself."
                ),
                ActStep(
                    title: "Field Verification",
                    textBullets: [
                        "Walk the property with the client to confirm observed reductions.",
                        "Capture side-by-side photos and short video clips from identical angles.",
                        "Document qualitative feedback for the final report."
                    ],
                    imageName: "act4_verify",
                    caption: "Validation builds credibility and client trust."
                ),
                ActStep(
                    title: "Reporting Results",
                    textBullets: [
                        "Generate interim and close-out reports using Act III logs.",
                        "Attach charts, photos, and signatures to each record.",
                        "Deliver the package digitally and store a signed copy."
                    ],
                    imageName: "act4_reports",
                    caption: "Clear reporting is the signature of professionalism."
                ),
                ActStep(
                    title: "Decision Gate – Pass or Repeat",
                    textBullets: [
                        "≥ 70 % reduction → proceed to Act V.",
                        "50 – 69 % → adjust methods and repeat monitoring cycle.",
                        "< 50 % → initiate diagnostic review and root-cause analysis."
                    ],
                    imageName: "act4_gate",
                    caption: "Let the numbers decide the next move — not ego."
                )
            ],
            nextActBuilder: {
                AnyView(Act5_OverviewView())
            }
        )
    }
}
