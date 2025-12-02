//
//  FinalCongratsView.swift
//  NPFG
//
//  Created by Eric Stewart on 10/21/25.
//

import SwiftUI

struct FinalCongratsView: View {
    var onUnlockPremium: () -> Void = {}
    var onReturnHome: () -> Void = {}

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "trophy.fill")
                .font(.system(size: 80, weight: .bold))
                .foregroundColor(.green)
                .shadow(color: .green.opacity(0.8), radius: 20)

            Text("Outstanding Work!")
                .font(.largeTitle.bold())
                .foregroundColor(.white)

            Text("You’ve completed the entire Night Plinkers Introduction — Acts I through V Overview.")
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal, 32)

            VStack(spacing: 16) {
                Button {
                    onUnlockPremium()
                } label: {
                    Label("Unlock Premium Modules", systemImage: "lock.open.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)

                Button {
                    // Prefer the passed callback; fall back to dismiss
                    if let _ = Mirror(reflecting: onReturnHome).children.first {
                        onReturnHome()
                    } else {
                        dismiss()
                    }
                } label: {
                    Label("Return Home", systemImage: "house.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .tint(.gray)
            }
            .padding(.horizontal, 40)

            Spacer()
        }
        .background(Color.black.ignoresSafeArea())
        .preferredColorScheme(.dark)
    }
}
