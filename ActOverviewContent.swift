//
//  ActOverviewContent.swift
//  NPFG
//
//  Created by Eric Stewart on 10/21/25.
//

import SwiftUI

enum ActIntro: Hashable {
    case act1, act2, act3, act4, act5
}

struct ActSection: Identifiable {
    let id = UUID()
    let title: String
    let bullets: [String]
}

struct ActOverview {
    let title: String
    let subtitle: String
    let intro: String
    let sections: [ActSection]
    let deliverables: [String]
    let premiumPitch: String
}

extension ActIntro {
    var data: ActOverview {
        switch self {
        case .act1:
            return ActOverview(
                title: "Act I — The Beginning",
                subtitle: "Discovery & Trust",
                intro: "Every operation begins not with the airgun, but with a handshake. Trust, professionalism, and clarity of purpose set the tone.",
                sections: [
                    ActSection(title: "The First Contact", bullets: [
                        "Listen first; let the client describe damage and sightings.",
                        "Your role: Observer, not yet problem-solver.",
                        "Take notes and (with permission) capture photos/video."
                    ]),
                    ActSection(title: "Understanding the Problem", bullets: [
                        "Walkthrough: client points out hotspots and damage.",
                        "Checklist: species, evidence, prior attempts, frequency & scale."
                    ]),
                    ActSection(title: "Agreeing on Goals (≥70%)", bullets: [
                        "Explain why 70% reduction is the tipping point.",
                        "Clarify: control and prevention, not eradication.",
                        "Capture agreement in writing."
                    ]),
                    ActSection(title: "Paperwork", bullets: [
                        "Authorization to Operate",
                        "Hold Harmless & Indemnity",
                        "Scope & Success Agreement (70% target)",
                        "Emergency Contact Sheet"
                    ])
                ],
                deliverables: [
                    "Signed authorization packet",
                    "Intake form with notes/maps/photos",
                    "Definition of success (≥70% reduction)",
                    "Daylight Recon scheduled (Act II)"
                ],
                premiumPitch: "Unlock interactive intake forms, digital signatures, and auto-generated Act I PDF."
            )
        case .act2:
            return ActOverview(
                title: "Act II — Setting the Stage",
                subtitle: "Planning & Preparation",
                intro: "The handshake is complete. Now responsibility shifts to operator preparation — lawful, repeatable, safe.",
                sections: [
                    ActSection(title: "The Legal Crossroads", bullets: [
                        "Confirm applicable laws & ordinances before field work.",
                        "Document a Legal Compliance Memo (no memo, no mission)."
                    ]),
                    ActSection(title: "Daylight Recon", bullets: [
                        "Map boundaries, backstops, no-shoot zones.",
                        "Document hotspots; GPS-tagged photos logged."
                    ]),
                    ActSection(title: "The Safety Net", bullets: [
                        "Carcass disposal & biosecurity plan.",
                        "Emergency response & neighbor relations."
                    ]),
                    ActSection(title: "The Team & Tools", bullets: [
                        "Operator skills verified; training logs up to date.",
                        "Equipment check: airgun, ammo, optics, radios, PPE."
                    ])
                ],
                deliverables: [
                    "Signed Legal Compliance Memo",
                    "Recon Map & Safety Plan",
                    "Carcass & Biosecurity Plan",
                    "Verified Team Roster & Training",
                    "Checked & Approved Equipment List"
                ],
                premiumPitch: "Unlock map-based recon, safety plan generator, and pre-op checklists with export."
            )
        case .act3:
            return ActOverview(
                title: "Act III — The Challenge",
                subtitle: "Execution & Control",
                intro: "Planning becomes action — quiet, humane, documented. Patience, precision, and paperwork.",
                sections: [
                    ActSection(title: "Pre-Departure", bullets: [
                        "Weather & visibility check; crew ready; comms charged."
                    ]),
                    ActSection(title: "On-Site Execution", bullets: [
                        "Safe arcs enforced; humane dispatch; evidence logged.",
                        "Adaptive loop: adjust tactics as conditions change."
                    ]),
                    ActSection(title: "Documentation", bullets: [
                        "Nightly AAR notes and action items.",
                        "Update recon map if arcs/no-shoot zones change.",
                        "Capture monitoring snapshot for Act IV."
                    ])
                ],
                deliverables: [
                    "Operator logs & media",
                    "Updated field map",
                    "Monitoring snapshot ready for Act IV"
                ],
                premiumPitch: "Unlock live shot log, AAR templates, and media tagging with GPS/time."
            )
        case .act4:
            return ActOverview(
                title: "Act IV — The Turning Point",
                subtitle: "Measuring Success",
                intro: "Did the plan work? The question is answered with numbers and matching methodology.",
                sections: [
                    ActSection(title: "Re-Survey & Monitoring", bullets: [
                        "Measure at 2/4/8 weeks with same methods & routes.",
                        "Standardize: same operators, gear, time, conditions."
                    ]),
                    ActSection(title: "Statistical Comparison", bullets: [
                        "Compute encounter indices & percentage reduction.",
                        "Target: ≥70% reduction; include confidence intervals."
                    ]),
                    ActSection(title: "Field Verification & Reporting", bullets: [
                        "Client walk-through; side-by-side photos.",
                        "Interim reports and final closeout report."
                    ])
                ],
                deliverables: [
                    "Completed monitoring dataset",
                    "Statistical Reduction Report",
                    "Photographic evidence",
                    "Client-verified Reduction Confirmation",
                    "Closeout Report (if successful)"
                ],
                premiumPitch: "Unlock calculators, charting, and auto-formatted reports with confidence intervals."
            )
        case .act5:
            return ActOverview(
                title: "Act V — Holding the Ground",
                subtitle: "Maintenance & Prevention",
                intro: "Prevention and client education keep the win. Prepare rapid response if rebound occurs.",
                sections: [
                    ActSection(title: "Prevention & Education", bullets: [
                        "Exclusion & sanitation plan; client visual aids.",
                        "Direct reporting line for early signs."
                    ]),
                    ActSection(title: "Rapid Response Agreement", bullets: [
                        "Trigger if rebound >20% of post-control baseline.",
                        "Pre-approved response terms & timelines."
                    ])
                ],
                deliverables: [
                    "Customized Prevention & Exclusion Plan",
                    "Monitoring & Maintenance Schedule",
                    "Client Education Materials",
                    "Rapid Response Protocol",
                    "Final Closeout Report with Success Certification"
                ],
                premiumPitch: "Unlock prevention planner, maintenance reminders, and quick-deploy response templates."
            )
        }
    }
}

