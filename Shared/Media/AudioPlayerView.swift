//
//  AudioPlayerView.swift
//  NPFG
//
//  Created by Eric Stewart on 11/29/25.
//

import SwiftUI
import AVFoundation

struct AudioPlayerView: View {
    let audioURL: URL

    @State private var player: AVAudioPlayer?

    var body: some View {
        HStack(spacing: 20) {
            Button {
                play()
            } label: {
                Image(systemName: "play.fill")
                    .font(.title)
                    .foregroundColor(.green)
            }

            Button {
                pause()
            } label: {
                Image(systemName: "pause.fill")
                    .font(.title)
                    .foregroundColor(.green)
            }
        }
        .onDisappear {
            player?.stop()
        }
    }

    private func play() {
        do {
            player = try AVAudioPlayer(contentsOf: audioURL)
            player?.prepareToPlay()
            player?.play()
        } catch {
            print("❌ Audio playback failed:", error)
        }
    }

    private func pause() {
        player?.pause()
    }
}
