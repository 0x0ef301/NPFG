//
//  MediaListView.swift
//  NPFG
//
//  Created by Eric Stewart on 11/29/25.
//  Corrected by Gert
//

import SwiftUI

struct MediaListView: View {

    let items: [NPMediaItem]
    let onDelete: (NPMediaItem) -> Void

    var body: some View {
        List {
            ForEach(items) { item in
                NavigationLink {
                    MediaPreviewView(item: item) {
                        onDelete(item)
                    }
                } label: {
                    HStack(spacing: 16) {
                        thumbnail(for: item)
                            .frame(width: 60, height: 60)
                            .clipShape(RoundedRectangle(cornerRadius: 8))

                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.originalFileName)
                                .foregroundColor(.white)
                            Text(item.type.rawValue)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }

                        Spacer()

                        Text(item.createdAt.formatted(date: .numeric, time: .shortened))
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }
            }
            .onDelete { indexSet in
                for idx in indexSet {
                    onDelete(items[idx])
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.black.ignoresSafeArea())
        .preferredColorScheme(.dark)
    }

    // MARK: - Thumbnail Helper
    @ViewBuilder
    func thumbnail(for item: NPMediaItem) -> some View {

        let url: URL? = {
            // Supports both absolute and file:// paths
            URL(string: item.filePath) ?? URL(fileURLWithPath: item.filePath)
        }()

        switch item.type {

        case .photo:
            if let url = url,
               let image = MediaManager.shared.loadPhoto(at: url) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                placeholder(icon: "photo")
            }

        case .video:
            if let url = url,
               let image = MediaManager.shared.loadVideoThumbnail(at: url) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                placeholder(icon: "video")
            }

        case .audio:
            placeholder(icon: "waveform.circle.fill")
        }
    }

    // MARK: - Placeholder
    func placeholder(icon: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.2))

            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundColor(.green)
        }
    }
}

