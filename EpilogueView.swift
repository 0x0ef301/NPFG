//
//  EpilogueView.swift
//  NPFG
//
//  Created by Eric Stewart on 10/29/25.
//
import SwiftUI

struct EpilogueView: View {
    var onUnlockPremium: () -> Void = {}
    var onReturnHome: () -> Void = {}

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            // Logo + glow
            Image("NightPlinkersLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 180, height: 180)
                .shadow(color: .green.opacity(0.9), radius: 25)
                .shadow(color: .green.opacity(0.6), radius: 50)

            Text("Epilogue")
                .font(.largeTitle.bold())
                .foregroundColor(.white)

            Text("You’ve completed the Night Plinkers Introduction (Acts I–V). You know the arc: trust, plan, execute, measure, and hold the ground you win.")
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal, 28)

            VStack(alignment: .leading, spacing: 10) {
                bullet("Act I: Discovery & trust; the 70% target.")
                bullet("Act II: Lawful, safe, prepared.")
                bullet("Act III: Humane, documented execution.")
                bullet("Act IV: Numbers prove success.")
                bullet("Act V: Prevention keeps it.")
            }
            .padding(.horizontal, 28)

            Spacer()

            VStack(spacing: 14) {
                Button {
                    onUnlockPremium()
                } label: {
                    Label("Unlock Premium Modules", systemImage: "lock.open.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)

                Button {
                    onReturnHome()
                } label: {
                    Label("Return Home", systemImage: "house.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .tint(.gray)
            }
            .padding(.horizontal, 40)

            Spacer(minLength: 24)
        }
        .background(Color.black.ignoresSafeArea())
        .preferredColorScheme(.dark)
    }

    private func bullet(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Circle().fill(Color.green).frame(width: 6, height: 6).padding(.top, 6)
            Text(text).foregroundColor(.white)
        }
    }
}
