//
//  AppRoot.swift
//  NPFG
//
//  Created by Eric Stewart on 10/21/25.
//

import SwiftUI

struct AppRoot: View {
    @EnvironmentObject var appState: AppState
    @State private var showSplash = true

    var body: some View {
        ZStack {
            if showSplash {
                SplashView()
                    .transition(.opacity)
            } else {
                RootTabView()
                    .transition(.opacity)
            }
        }
        .onAppear {
            // Guarantee at least 5 seconds of splash
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                withAnimation(.easeInOut(duration: 0.35)) {
                    showSplash = false
                }
            }

            // (Optional) do any warm-up work here while splash is showing:
            // - Preload user defaults
            // - Prime caches
            // - Run a lightweight integrity check
        }
    }
}
