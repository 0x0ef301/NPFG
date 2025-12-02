//
//  Act1_OverviewView.swift
//  NPFG
//
//  Created by Eric Stewart on 10/21/25.
//

import SwiftUI

struct Act1_OverviewView: View {
    var body: some View {
        ActFlowView(def: act1Def)
    }

    // Replace imageName strings with your Asset names (or nil to hide visual card)
    private var act1Def: ActDefinition {
        ActDefinition(
            actNumber: 1,
            actTitle: "The Beginning",
            actSubtitle: "Discovery & Trust",
            steps: [
                ActStep(
                    title: "First Contact: Listen First",
                    textBullets: [
                        "Client describes damage and sightings.",
                        "You are the observer, not yet the problem-solver.",
                        "With permission, capture reference photos or a short video."
                    ],
                    imageName: "act1_firstcontact",  // add to Assets.xcassets
                    caption: "Listen carefully; the client’s story guides the mission."
                ),
                ActStep(
                    title: "Understanding the Problem",
                    textBullets: [
                        "Walk with the client and mark hotspots.",
                        "Checklist: species, evidence, prior attempts, frequency & scale."
                    ],
                    imageName: "act1_hotspots",
                    caption: "Example hotspots: burrows, droppings, chew marks, feed stores."
                ),
                ActStep(
                    title: "Agreeing on Goals (≥70%)",
                    textBullets: [
                        "Explain the 70% reduction tipping point.",
                        "Clarify: control & prevention, not eradication.",
                        "Capture the agreement in writing."
                    ],
                    imageName: "act1_goal70",
                    caption: "Success is a measurable reduction to safe levels."
                ),
                ActStep(
                    title: "Paperwork",
                    textBullets: [
                        "Authorization to Operate",
                        "Hold Harmless & Indemnity",
                        "Scope & Success Agreement (70% target)",
                        "Emergency Contact Sheet"
                    ],
                    imageName: "act1_docs",
                    caption: "Paperwork protects the client, operator, and the mission."
                ),
                ActStep(
                    title: "Schedule Daylight Recon",
                    textBullets: [
                        "Pick date/time for Act II.",
                        "Create calendar reminder."
                    ],
                    imageName: "act1_schedule",
                    caption: "Recon sets the stage for safe, lawful execution."
                )
            ],
            nextActBuilder: {
                AnyView(Act2_OverviewView())
            }
        )
    }
}
