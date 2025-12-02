//
//  MediaPreviewView.swift
//  NPFG
//
//  Created by Eric Stewart on 11/29/25.
//  Corrected & Updated by Gert on 12/01/25
//

import SwiftUI
import AVKit

struct MediaPreviewView: View {

    let item: NPMediaItem
    let onDelete: () -> Void

    @Environment(\.dismiss) private var dismiss

    // Convert stored string path → URL
    private var fileURL: URL? {
        URL(string: item.filePath) ?? URL(fileURLWithPath: item.filePath)
    }

    var body: some View {
        NavigationStack {
            content
                .background(Color.black.ignoresSafeArea())
                .preferredColorScheme(.dark)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Close") { dismiss() }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(role: .destructive) {
                            onDelete()
                            dismiss()
                        } label: {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }
                }
        }
    }

    // MARK: - Content
    @ViewBuilder
    var content: some View {
        switch item.type {

        // --------------------------
        // MARK: PHOTO
        // --------------------------
        case .photo:
            if let url = fileURL,
               let img = MediaManager.shared.loadPhoto(at: url) {

                Image(uiImage: img)
                    .resizable()
                    .scaledToFit()
                    .padding()

            } else {
                Text("Unable to load image")
                    .foregroundColor(.white)
            }

        // --------------------------
        // MARK: VIDEO
        // --------------------------
        case .video:
            if let url = fileURL {
                VideoPlayer(player: AVPlayer(url: url))
                    .ignoresSafeArea()
            } else {
                Text("Unable to load video")
                    .foregroundColor(.white)
            }

        // --------------------------
        // MARK: AUDIO
        // --------------------------
        case .audio:
            VStack(spacing: 24) {

                Image(systemName: "waveform.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.green)
                    .padding(.top, 40)

                if let url = fileURL {
                    AudioPlayerView(audioURL: url)
                        .frame(height: 80)
                        .padding(.horizontal, 20)
                } else {
                    Text("Unable to load audio")
                        .foregroundColor(.white)
                }

                Spacer()
            }
        }
    }
}

