//
//  Act2_OverviewView.swift
//  NPFG
//
//  Created by Eric Stewart on 10/21/25.
//

import SwiftUI

struct Act2_OverviewView: View {
    var body: some View {
        ActFlowView(def: def)
    }

    private var def: ActDefinition {
        ActDefinition(
            actNumber: 2,
            actTitle: "Setting the Stage",
            actSubtitle: "Planning & Preparation",
            steps: [
                ActStep(
                    title: "Legal Compliance",
                    textBullets: [
                        "Confirm statutes & ordinances.",
                        "Draft the Legal Compliance Memo with contacts."
                    ],
                    imageName: "act2_legal",
                    caption: "No memo, no mission."
                ),
                ActStep(
                    title: "Daylight Recon",
                    textBullets: [
                        "Map boundaries, backstops, no-shoot zones.",
                        "Document hotspots with GPS-tagged photos."
                    ],
                    imageName: "act2_recon",
                    caption: "This becomes your Field Playbook."
                ),
                ActStep(
                    title: "Safety Net",
                    textBullets: [
                        "Carcass disposal & biosecurity plan.",
                        "Emergency response & neighbor relations."
                    ],
                    imageName: "act2_safety",
                    caption: "Planning reduces risk."
                ),
                ActStep(
                    title: "Team & Tools",
                    textBullets: [
                        "Verify skills/training and insurance as required.",
                        "Pre-op equipment checklist: airgun, optics, radios, PPE."
                    ],
                    imageName: "act2_tools",
                    caption: "Every piece of gear earns its place."
                ),
                ActStep(
                    title: "Act II Deliverables",
                    textBullets: [
                        "Signed Legal Compliance Memo.",
                        "Recon Map & Safety Plan.",
                        "Carcass & Biosecurity Plan.",
                        "Verified Team Roster & Training.",
                        "Checked & Approved Equipment List."
                    ],
                    imageName: "act2_deliver",
                    caption: "Advance to Act III when all five are complete."
                )
            ],
            nextActBuilder: {
                AnyView(Act3_OverviewView())
            }
        )
    }
}
